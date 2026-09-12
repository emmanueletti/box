# Security

Threat model: lost/stolen machine. Holds business data, prod server access,
1Password. Goal: lost device is a non-event, down to two memorized secrets
(machine unlock, 1Password master).

## Full disk encryption: LUKS2 + TPM2 + PIN

LUKS2 encrypts the disk. Without it, a pulled drive reads freely on another
machine.

TPM-only auto-unlock is bad for a stolen-laptop threat model: thief powers on,
TPM sees a normal boot, hands over the key.

TPM2 + PIN (`systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes`): TPM
hardware-throttles PIN guesses (exponential backoff, eventual lockout). Key is
sealed in the chip, not derived from the PIN, so a short PIN is safe —
brute-force resistance comes from hardware, not passphrase entropy.

Chosen setup: TPM2 + PIN. This is the "machine password."

Caveat: PCR-bound keys are brittle. A firmware/kernel/bootloader update changes
PCR values, TPM refuses to release the key, falls back to a recovery passphrase.
Availability issue, not a security one. Keep the recovery passphrase in
1Password. Secure Boot keeps PCR values stable across routine updates.

TODO: automate re-enrollment as a box postinstall step — a hook that re-runs
`systemd-cryptenroll` automatically after a successful passphrase-fallback
unlock, so PCR drift doesn't require manually re-sealing each time. Not built
yet.

Not yet implemented — current disk is unencrypted.

### Recovery passphrase strength

The recovery passphrase is a different secret from the TPM2 PIN, with a
different threat model. The PIN is attempt-limited by TPM hardware, so a short
one is fine. The recovery passphrase has no such limit — it's a keyslot on the
LUKS header itself, so anyone with the raw disk can attack it fully offline,
unlimited time, unlimited attempts. Entropy is the only defense here.

LUKS2's default KDF (Argon2id) is memory-hard — expensive to parallelize on
GPUs/ASICs, so each guess costs real time and memory. That raises the cost per
guess, but doesn't cap the number of guesses, so the passphrase still has to
carry real entropy on its own.

Use diceware, not an invented phrase: roll dice against the EFF long wordlist
(7776 words, ~12.9 bits/word) rather than composing something that sounds
random, since actual language follows patterns that make invented phrases far
weaker than they look.

| Words | Entropy  |
| ----- | -------- |
| 4     | ~52 bits |
| 5     | ~65 bits |
| 6     | ~78 bits |
| 7     | ~90 bits |

Recommendation: 6+ words (~78+ bits). This passphrase is typed rarely (only on
PCR-drift fallback), so length costs almost nothing in daily friction and buys a
comfortable margin against offline attack over the life of the machine.

Illustrative shape only, never reuse verbatim: `correct horse battery staple`
(the classic public example) shows the _form_ — random dictionary words chosen
by dice, not judgment. Generate your own with a `diceware` tool or physical
dice.

Equivalent alternative: a fully random string via `box-random-password 20` (~119
bits at 6 characters of entropy each) — comfortably past the 6-word diceware
target, at the cost of being harder to type by hand if the recovery path ever
needs manual entry without a password manager available.

## Single-password UX

One memorized secret for the machine (TPM2 PIN), one for 1Password.

- User account password = LUKS unlock secret. One secret, two stores.
- tty autologin (systemd getty override, `agetty --autologin`) after disk
  unlock, then a `.zprofile` guard execs the WM (Sway) on that tty. Real
  security boundary already passed at the LUKS/PIN prompt; a second login prompt
  adds friction, not protection. Adapt this line to whatever your login path
  actually is (a display manager's own autologin setting works the same way if
  you're using one).
- Screen lock (`swaylock`) reuses the same PAM password, triggered by `swayidle`
  on idle timeout and on any suspend (lid-close or otherwise).
- 1Password SSH agent handles prod server keys — no raw private key files on
  disk. Unlock 1Password once, the agent signs on demand. Also autofills service
  logins.

### How strong does the shared secret need to be?

This one secret does two jobs with two different threat models, and the weaker
one sets the real requirement:

- As the **TPM2 PIN**, it's attempt-limited by hardware — the TPM's lockout
  counter caps total guesses regardless of guessing speed. A short PIN is
  genuinely safe here; entropy isn't the binding constraint.
- As the **Linux account password** (PAM), it gets no such protection. If
  `/etc/shadow` were ever exfiltrated, or a network login path existed, this is
  a normal password subject to normal offline cracking.

Because it's reused as the login password, treat it like one: don't drop to a
bare numeric PIN just because the TPM side would tolerate it. A 4-digit PIN (~13
bits) is fine standing alone behind hardware lockout, but is a weak
`/etc/shadow` entry on its own merits.

| Form                        | Entropy  |
| --------------------------- | -------- |
| 4-digit PIN                 | ~13 bits |
| 6-digit PIN                 | ~20 bits |
| 3 diceware words            | ~39 bits |
| 4 diceware words            | ~52 bits |
| 8 random alphanumeric chars | ~48 bits |

Recommendation: 3–4 diceware words (~39–52 bits), or an 8+ character random
string. Typed daily (no autologin skips this one, screen lock reuses it too), so
keep it shorter than the recovery passphrase — but long enough that it isn't
trivially weak the moment it's evaluated as a plain login password instead of a
hardware-throttled PIN.

### Secret Service keyring: passwordless, not synced

GNOME Keyring is a separate locked store (browsers, VS Code, anything via
`libsecret`). `pam_gnome_keyring.so` normally unlocks it with the login
password. Autologin breaks that — no password typed at login to capture — which
shows up as extra unlock prompts after login.

Fix:

- Default keyring unencrypted, never-locking (`lock-on-idle=false`,
  `lock-after=false`).
- Strip `pam_gnome_keyring.so` from the login PAM stack (`/etc/pam.d/login` for
  a tty login; whatever service file your login path uses otherwise) — moot
  anyway once autologin skips password entry at login, same reasoning as above.
- Start it with an `exec gnome-keyring-daemon --start --components=secrets` line
  in the Sway config, no unlock step. No XDG-autostart session manager to rely
  on without a full DE, so this has to be explicit.

LUKS2 + TPM2/PIN is already the real security boundary on a single-user machine.
A second locked keyring protects against a threat (another local user reading
saved passwords) that doesn't apply here.

- Wi-Fi: NetworkManager, set as system-wide connections rather than per-user
  (`.nmconnection` files under `/etc/NetworkManager/system-connections/`,
  root-owned) — sidesteps the keyring for network secrets entirely, same outcome
  `iwd` would give, without switching stacks.
- Apps with a secret-backend choice (VS Code etc): point at `gnome-libsecret`
  explicitly, so they use the always-open keyring instead of falling back to an
  encrypted file store that prompts.

## IOMMU and Thunderbolt

Framework 13 exposes Thunderbolt/USB4 — DMA-capable, historically used to defeat
disk encryption via direct memory access.

The threat: a DMA-capable device gets direct read/write access to physical RAM,
bypassing the CPU and OS entirely. The classic evil-maid case is a malicious
Thunderbolt device (disguised as a dock or cable) plugged in for a moment while
the machine is awake and unlocked — it reads the LUKS key straight out of RAM,
no login, no OS cooperation needed. LUKS2+TPM2+PIN protects the disk while it's
off or locked; it does nothing against this, since the machine is unlocked and
running when the attack happens.

- IOMMU on: `intel_iommu=on iommu=pt` (or `amd_iommu=on iommu=pt` on the AMD
  board). Forces every DMA-capable device through address translation and
  permission checks instead of raw physical-memory access. `pt` ("passthrough")
  keeps this near 1:1 for the machine's own trusted internal devices, so only
  new/external devices actually get policed.
- `bolt` Thunderbolt security level "user": new devices need explicit approval
  before DMA access. Without this, Thunderbolt ports often default to trusted —
  plug in, it's live.

Skipping this doesn't weaken the disk encryption itself, it just leaves the one
window where encryption doesn't help at all — machine awake and unlocked — fully
open on any exposed Thunderbolt/USB4 port.

## USB protection

`bolt` above only covers Thunderbolt/USB4 DMA. Plain USB ports are a different,
more common attack: a malicious USB device posing as a keyboard (BadUSB, rogue
HID) injecting keystrokes, or acting as a mass-storage device to exfiltrate data
— no DMA needed, just the OS trusting whatever identifies itself as a keyboard.

`usbguard` is the USB equivalent of `bolt`'s device-approval model:

- `apt install usbguard`.
- Generate an allow-list from currently-connected devices:
  `usbguard generate-policy > /etc/usbguard/rules.conf`. Anything already
  plugged in when the policy is generated is trusted; anything plugged in later
  needs explicit approval.
- Same cost/benefit shape as `bolt`: one approval prompt per new device,
  invisible otherwise.

## Kernel hardening

Sysctl (`/etc/sysctl.d/99-hardening.conf`):

- `kernel.yama.ptrace_scope=1` — restricts `ptrace` to parent-child processes
  only. Blocks a common local attack primitive: a malicious browser extension or
  compromised process reading another process's memory (session tokens,
  credentials) via `ptrace`. Real, practical value on a single-user desktop
  running a browser daily.
- `kernel.kptr_restrict=2` — hides kernel pointers from unprivileged users,
  closes a minor info-leak used to defeat kernel ASLR.
- `kernel.dmesg_restrict=1` — restricts `dmesg` to privileged users.

Kernel command line (`GRUB_CMDLINE_LINUX` in `/etc/default/grub`, then
`update-grub`):

- `slab_nomerge` — stops the allocator merging different slab caches, which
  closes off a common kernel heap-exploitation technique (cache-crossing
  overwrites).
- `init_on_alloc=1 init_on_free=1` — zeroes memory at allocation and free,
  closing use-after-free and uninitialized-memory info leaks. Small, measurable
  perf cost (single-digit % on memory-heavy workloads) — worth it on a machine
  that isn't performance-starved.
- `page_alloc.shuffle=1` — randomizes the page allocator's freelists, making
  memory layout harder to predict for exploits relying on allocation order.

Skip restricting unprivileged user namespaces, even though it's a common
hardening recommendation elsewhere: rootless Podman (already in `packages.list`)
depends on unprivileged user namespaces to run containers without root. Locking
that down breaks the existing container workflow outright — real conflict, not a
hypothetical one, given what's actually installed on this machine.

## AppArmor

Debian's default MAC (mandatory access control), enabled out of the box since
Debian 10. No reason to reach for SELinux instead — that's Fedora/RHEL's default
and gets first-party policy maintenance there, not on Debian.

- `aa-status` shows what's actually enforcing right now — the default install is
  usually thin, a handful of profiles.
- `apt install apparmor-profiles apparmor-profiles-extra` for broader coverage
  beyond the stock set.
- Confirm a profile is safe before switching it from complain to enforce
  (`aa-complain`/`aa-enforce`) — complain mode logs violations without blocking,
  useful for testing a profile before committing to it.

## unattended-upgrades

Automatic security-suite patching. Matters more here than it would on a
fast-releasing distro — this machine isn't getting reinstalled every 6 months,
so staying current between manual updates is the main lever available.

- `apt install unattended-upgrades`, enable the `-security` suite in
  `/etc/apt/apt.conf.d/50unattended-upgrades`.
- `Unattended-Upgrade::Automatic-Reboot` — decide deliberately rather than
  leaving the default. Auto-reboot actually applies kernel/library updates that
  need a restart to take effect, but an unplanned reboot on a personal machine
  has its own cost (lost work, and autologin means it comes back up unlocked at
  the tty rather than waiting for you).

https://madaidans-insecurities.github.io/guides/linux-hardening.html

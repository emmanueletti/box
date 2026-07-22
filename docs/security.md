# Security

Threat model for box: primary risk is a lost or stolen machine, not a nation-state
attacker. The machine holds business data, prod server access, and 1Password. Goal
is to make a lost device a non-event, keep daily use practical, and stay down to two
memorized secrets: the machine unlock and the 1Password master password.

## Full disk encryption: LUKS2 + TPM2 + PIN

LUKS2 encrypts the whole disk. Without it, a stolen drive can just be pulled and
read on another machine.

Two ways to unlock LUKS2 with a TPM2 chip, and they behave very differently:

- **TPM-only auto-unlock**: TPM releases the key automatically if the boot chain
  measurement (PCR) matches. No user input. Bad for a stolen-laptop threat model:
  thief powers it on, TPM sees a normal boot, hands over the key. Encryption
  becomes moot for anyone who has the whole machine, not just the drive.
- **TPM2 + PIN** (`systemd-cryptenroll --tpm2-device=auto --tpm2-with-pin=yes`):
  TPM enforces a hardware dictionary-attack lockout on PIN guesses (exponential
  backoff, eventual hard lockout). The disk key is sealed in the chip, not derived
  from the PIN, so every guess has to interact with physical hardware and gets
  throttled. This lets the daily secret be a short PIN instead of a long
  passphrase, with brute-force resistance coming from the hardware lockout rather
  than passphrase entropy.

Chosen setup: TPM2 + PIN. This is the "machine password."

Caveat: PCR-bound keys are brittle. A firmware, kernel, or bootloader update
changes PCR values, and the TPM refuses to release the key, falling back to a
recovery passphrase. Not a security problem, an availability one. Keep a recovery
passphrase backed up in 1Password. Secure Boot (below) helps keep PCR values more
stable across routine updates.

## Single-password UX

Goal: one memorized secret for the machine (the TPM2 PIN), one for 1Password. No
sprawl of remembered service passwords.

- User account password matches the LUKS unlock secret. Two stores, one secret.
- Display manager autologin after disk unlock. The real security boundary already
  passed at the LUKS/PIN prompt; a second login prompt right after doesn't add
  protection, just friction.
- Screen lock (hyprlock) reuses the same PAM password. Same secret typed again
  during the day, not a new one to remember.
- 1Password SSH agent handles all prod server keys. No raw private key files on
  disk. Unlock 1Password once (master password or biometric), the agent signs on
  demand for every SSH connection. 1Password also autofills service logins, so
  those never need memorizing either.

### Secret Service keyring: make it passwordless, don't sync it

A common source of extra prompts: GNOME Keyring (or KWallet) is a *separate*
locked store from the login password, used by browsers, VS Code, and anything
calling `libsecret` for saved credentials. Normally `pam_gnome_keyring.so`
captures the password typed at the login prompt and uses it to unlock the
keyring silently in the same step. Autologin breaks that, since no password
gets typed at login for it to capture, which is exactly why this shows up as
one or two extra unlock prompts after login.

Fix is to not fight this:

- Create the default keyring unencrypted and never-locking
  (`lock-on-idle=false`, `lock-after=false`), so there's nothing to unlock.
- Strip `pam_gnome_keyring.so` out of the display manager's PAM stack entirely,
  since there's no password to sync into a keyring that doesn't lock anyway.
- Start `gnome-keyring-daemon` at session autostart with no unlock step.

The reasoning holds for box: LUKS2 + TPM2/PIN is already the real security
boundary for a single-user machine. A second locked keyring on top of an
already-encrypted disk protects against a threat (another local user reading
your saved passwords) that doesn't apply here. Making it passwordless removes
the redundant prompt without giving anything up.

- Wi-Fi credentials: use `iwd` instead of NetworkManager. Profiles store as
  root-owned files under `/var/lib/iwd/`, sidestepping the keyring question for
  network secrets entirely.
- Apps that support choosing a secret backend (VS Code, etc.) should be pointed
  at `gnome-libsecret` explicitly, so they resolve to the same always-open
  keyring instead of falling back to an encrypted file store that would prompt.

## Sleep and hibernation

Plain sleep (S3) keeps RAM powered, which means the decryption key stays resident
in memory the whole time the lid is closed. A laptop grabbed off a coffee shop
table seconds after sleeping is not meaningfully protected by disk encryption
alone. This is true of any OS running plain sleep, not an Arch-specific problem.
Apple mitigates it on newer Macs by transitioning from sleep into a hibernation
state after a delay, which evicts the key from RAM entirely.

Equivalent on Linux: `suspend-then-hibernate`. Sleeps normally for fast resume on
short breaks, then automatically hibernates after a delay (evicting RAM, wiping
the key) if left idle longer. Configured via `/etc/systemd/sleep.conf`:

```
HibernateDelaySec=1800
```

Hibernation image must live inside the encrypted volume (swapfile inside the LUKS
container), otherwise the RAM contents get written to disk unencrypted and the key
leaks that way instead.

Screen lock fires immediately on lid-close or idle via hypridle, independent of
the sleep/hibernate transition itself.

## Secure Boot

Stops an attacker with brief physical access (evil-maid scenario: device out of
sight at a border facility, hotel room, etc.) from swapping the bootloader for one
that keylogs the LUKS PIN or installs a persistent implant.

Fedora and most major distros ship `shim`, pre-signed by Microsoft's third-party
UEFI CA, which is already trusted by nearly every OEM firmware out of the box.
Arch ships no signed shim or kernel, so Secure Boot on Arch is self-managed:

- **`sbctl`** (chosen approach): generate a Platform Key, KEK, and db, enroll them
  in firmware ("Setup Mode"), sign the kernel/initramfs/bootloader. `sbctl` ships
  a pacman hook that re-signs automatically on every kernel update.
- Run `sbctl enroll-keys --microsoft` alongside the custom keys, not instead of.
  Keeps a fallback trust chain for anything signed by Microsoft (Windows
  installer media, memtest86, other rescue tools) that would otherwise fail to
  boot with custom-only keys.

**Portability across reinstalls**: key enrollment lives in UEFI NVRAM, not on
disk. Reinstalling Arch doesn't wipe enrolled keys unless Secure Boot is manually
reset in firmware setup. What's lost on reinstall is the private signing key file
on the root filesystem. Back that up externally (1Password attachment) and
restore it before the first `sbctl sign` on a fresh install; no firmware
re-enrollment needed.

**BIOS/firmware updates**: Framework ships updates via fwupd/LVFS using UEFI
Capsule Update, which is normally verified against a separate vendor-embedded
signing cert baked into the firmware chip at manufacture, not the PK/KEK/db that
`sbctl` replaces. Custom keys typically don't block `fwupdmgr update`. Verify once
on real hardware rather than assuming. Safety net if a firmware update or rescue
tool ever gets blocked: toggling Secure Boot off/on in firmware setup does not
clear enrolled keys, only the "reset to factory defaults / clear keys" option
does — avoid that one specifically.

## IOMMU and Thunderbolt

Framework 13 exposes Thunderbolt/USB4 ports, which are DMA-capable and historically
used to defeat disk encryption via direct memory access (reading the key straight
out of RAM, bypassing the OS).

- IOMMU on generally, not just as an Apple-T2 special case:
  `intel_iommu=on iommu=pt` (or `amd_iommu=on iommu=pt` on the AMD board).
- `bolt` Thunderbolt security level set to "user": new devices require explicit
  approval before they get DMA access. Costs one approval prompt per new device,
  otherwise invisible.

## Snapshots and rollback

Arch is rolling release; an update can occasionally break the system. Btrfs
snapshots make that a non-event instead of a reinstall.

- Subvolume layout: `@`, `@home`, `@var`, `@swap` (swap kept outside snapshot
  scope, since it holds the hibernation image).
- `snap-pac`: automatic pre/post snapshot on every pacman transaction.
- Limine boot menu integration (same pattern omarchy uses): boot straight into a
  prior snapshot from the boot menu if an update breaks the system, no separate
  recovery media needed.

This isn't a security measure, it's an operational safety net for the "rolling
release update broke everything" failure mode.

## Tradeoff summary

| Component | Setup effort | Daily friction | Security payoff | Failure mode |
|---|---|---|---|---|
| LUKS2 + TPM2 + PIN | Medium (one-time enroll, needs backed-up recovery passphrase) | Low, short PIN once per boot | High: stops lost-device data read, brute force hardware-throttled | PCR drift locks you out, falls back to recovery passphrase |
| suspend-then-hibernate | Low-medium (config is simple, but reliability varies by hardware) | Low if it works: fast resume on short breaks, auto-protects on long idle | Medium: shrinks the RAM cold-boot/DMA extraction window | Could fail to resume reliably on some hardware; annoyance, not exposure |
| Secure Boot (sbctl, custom keys) | Medium (one-time keygen/enroll, then automatic) | Zero after setup | Medium-high: stops evil-maid bootloader tampering | Low if Microsoft keys stay enrolled and firmware updates are tested once |
| IOMMU + Thunderbolt (bolt) policy | Low (kernel param + config) | Near zero, one approval prompt per new device | Medium: closes DMA attack surface on exposed ports | Essentially none |
| Btrfs snapshots (snapper + limine) | Medium (subvolume layout, hooks, boot integration) | Zero day-to-day | Not security: operational safety net for rolling-release breakage | Low; mainly snapshot retention/disk space to manage |

Net shape: everything here is one-time setup cost with near-zero recurring
friction, and failure modes are "locked out, use the backed-up recovery secret,"
not "silently insecure." None of it fights daily creative work once configured.

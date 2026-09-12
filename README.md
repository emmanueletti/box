# Box

A distraction free computing environment for focus and creativity.

## Install

```sh
git clone https://github.com/emmanueletti/box.git ~/box
cd ~/box
./setup.sh
```

## Usage

`BOX_ROOT` and `BOX_SCRIPTS_DIR` must already be set in the environment.

### Run a specific module

```sh
os/<os>/modules/<module>/setup.sh
```

### Run single step

```sh
os/<os>/modules/<module>/<step>.sh
```

### Secure boot (arch)

Enrolling your own secure boot keys needs a firmware reboot, which no script
can do for you. Do this once, right after installing arch and before running
box at all, so box's own install is a single, uninterrupted run:

1. Reboot, enter firmware setup, find the option that clears/resets secure
   boot keys (labeled differently per vendor: "Clear Secure Boot Keys",
   "Reset to Setup Mode", "Delete Platform Key"). Just switching
   "Secure Boot: Disabled" is not enough — that stops enforcement but leaves
   the Platform Key in place, and enrolling new keys needs no PK present
   (true Setup Mode).
2. Save, exit, boot back into arch.
3. Verify: `sudo sbctl status` shows `Setup Mode: Enabled`.
4. `sudo sbctl create-keys`
5. `sudo sbctl enroll-keys --microsoft` — enrolls your keys and the vendor
   certs together, so Windows and signed GPU/option-rom firmware still boot.
   This also re-activates secure boot enforcement on most firmware.
6. Reboot once, confirm `sudo sbctl status` shows `Setup Mode: Disabled` and
   `Secure Boot: Enabled`. Some vendor firmware needs the top-level
   "Secure Boot" switch flipped back to Enabled explicitly after clearing
   keys — check that menu again if step 5 didn't already show it enabled.
7. Run `./setup.sh`. Keys are already enrolled by now, so
   `04-system/001-setup-secureboot.sh` signs limine and the kernel and installs
   the resign hook in this same run — no re-running needed.

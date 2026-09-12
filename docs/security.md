# Security

Threat model: lost/stolen machine.

Goal: lost device is a non-event. No secrets on disk. Encrypted disk backed by
rate limiting TPM2.

## Full disk encryption

LUKS2 encrypts the disk preventing a pulled drive being freely read on another
machine.

TPM2 + PIN is enrolled to allow for a shorter, yet still strong, PIN for daily
use in decrypting the device. The TPM chip seals the encryption key behind
hardware rate limiting. After a certain number of unsuccesful PIN attempts, the
chip will fall back to requiring the full passphrase.

NOTE: PCR-bound keys are brittle. Aything that changes the bootchain like a
firmware/kernel/bootloader update change will also change PCR values, meaning
the TPM refuses to release the key and falls back to a recovery passphrase. Will
need to re-enroll the key after every fallback event.

Required passphrase strength: 6+ random diceware words Required TPM2 PIN: 3+
random diceware words

## Single-password UX

Making the root and user's account password the same as the TPM2 PIN, means that
a single password unlocks the device from boot, unlocks after idle, and allows
for sudo escalation, all for a low friction UX.

## Throttled login

Setup login to lock for an increasing amount of minutes after every X amount of
failures

### Passwordless secret Service keyring

Applications use secret stores like GNOME Keyring to store runtime secrets. This
is not needed for a single user machine with disk encryption set up and the
keyring will be set to never locking and default unencrypted.

## USB protection

A malicious USB device posing as a keyboard (BadUSB, rogue HID) injecting
keystrokes, or acting as a mass-storage device to exfiltrate data is a common
attack pattern. No DMA needed, just the OS trusting whatever identifies itself
as a keyboard.

`usbguard` applies a device-approval model to USB:

- Generate an allow-list from currently-connected devices:
  `usbguard generate-policy > /etc/usbguard/rules.conf`. Anything already
  plugged in when the policy is generated is trusted; anything plugged in later
  needs explicit approval.
- One approval prompt per new device, invisible otherwise.

## Further reading

- https://wiki.archlinux.org/title/Security

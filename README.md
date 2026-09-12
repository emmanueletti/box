# Box

A minimal computing environment for focused learning and creativity.

## Arch pre-install step

- Turn off secure boot as arch installation media does not work with it on
- Refer to Arch wiki for instructions for setting up secure boot again
- In archinstall, pick btrfs with snapper snapshots, the Limine bootloader, and
  add `linux-lts` as a second kernel

## Installation

```sh
git clone https://github.com/emmanueletti/box.git ~/box
cd ~/box
./setup.sh
```

## Usage

`BOX_ROOT` and `BOX_SCRIPTS_DIR` must already be set in the environment.

### Run a specific module

```sh
os/<OS>/modules/<MODULE>/all.sh
```

### Run a single step

```sh
os/<OS>/modules/<MODULE>/<step>.sh
```

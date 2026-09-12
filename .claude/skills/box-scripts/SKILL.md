---
name: box-scripts
description: Conventions for writing box scripts (box-* commands in scripts/.local/bin/box-scripts). Use when creating or editing any box-* script, its comment header, or the box-help contract. Covers the -h/box-help line, the header block box-help parses, and the beginner-first style box uses.
---
# Writing box scripts

box scripts: single bash 5 files in `scripts/.local/bin/box-scripts/`, named `box-<noun>-<action>`. Self-contained, run standalone.

Audience: beginner reading later, no agent. Pick the simplest pattern that works.

## Naming: `box-<noun>-<action>`

Noun first = namespace. Action last. Makes `box-<tab>` useful.

```
box-port-kill        not  box-kill-port
box-history-clear    not  box-clear-history
box-wallpaper-set     not  box-theme-wallpaper
```

No platform in name — script exits early if platform doesn't match. Nouns singular (`box-system-outdated`), except when the noun names a collection (`box-scripts-list`).

### Verbs

| kind | verbs |
|---|---|
| report | `status` `list` `check` |
| create | `new` `add` |
| destroy | `kill` `clear` `empty` |
| change | `set` `sync` `enable` `harden` |
| invoke | `run` `start` `setup` |

Domain verb only when a generic one loses meaning. Current set: `compress` `extract` `copy` `paste` `flush` `relink` `checkout` `restore`.

Exceptions: `box-random-*` (bytes/password/token/uuid) and `box-date-today` end in an object, not an action — everything in the namespace does the same thing, so the object is what varies. `box-help` and `box-open` shadow system verbs everyone knows.

## Header block (box-help contract)

box-help parses the comment block under the shebang — no registration.

- First non-blank comment line = one-line summary shown in `box-help`.
- Bare `#` = blank line in block.
- Indented lines starting with the command name = usage detail, shown by `-h`.
- Block ends at first non-comment line (`set -euo pipefail`).

Every script needs a summary line or `box-help --check` fails.

## Private scripts (`lib/`)

Scripts only other box scripts call live in `scripts/.local/bin/box-scripts/lib/`, named without the `box-` prefix. `lib/` is not on PATH, so the user never reaches for them by name. Two kinds: detectors whose output is parsed by another script (`lib/os-detect`, `lib/hw-detect`), and helpers that back a public command (`lib/screen-select` behind the capture scripts, `lib/launcher-entries` behind `box-launcher`).

A step of a multi-part command belongs in `lib/` only if it wouldn't be reached for alone. `box-system-update` runs public sub-steps (`box-os-update`, `box-pkgs-update`, ...) since running just one is a real want. `box-server-setup` runs `lib/server-power`, ... since they're one-time toggles, not everyday commands.

Call them by path, resolved from the calling script so it works through the stow symlink:

```bash
lib="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib"
"$lib/os-detect"
```

Inside `lib/` itself, drop the trailing `/lib`. box-help lists `box-*` only.

## The -h line

```bash
[[ ${1:-} == -h ]] && exec box-help "$0"
```

Passing `$0` lets box-help print the script's own header.

## Template

```bash
#!/usr/bin/env bash
#
# One-line summary -- shown in the box-help listing.
#
#   box-noun-action <arg>  # detail line, shown by box-help box-noun-action
#   box-noun-action --all  # another mode

set -euo pipefail

[[ ${1:-} == -h ]] && exec box-help "$0"

# ... work here
```

`chmod +x`. Scripts dir is stow-folded — new file is on PATH immediately, no re-stow.

## Standalone rule

Script must run on its own, not just via setup.sh. Detect OS with `lib/os-detect`:

```bash
lib="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/lib"

os="$("$lib/os-detect")"
```

Dispatch per-OS work on that value (`macos`, `arch`, `fedora`).

## Shared helpers

Put logic 2+ scripts share in a `lib/` script (see Private scripts). Add one only when the logic is real, not for a one-liner.

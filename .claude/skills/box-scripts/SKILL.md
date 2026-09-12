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

## Private scripts (`_box-*`)

Leading underscore = not reached for by name. Two kinds: detectors whose output is parsed by another script (`_box-os-detect`, `_box-hw-detect`), and narrower variants of a public command (`_box-config-sync` next to `box-system-sync`).

A step of a multi-part command qualifies only if it wouldn't be reached for alone. `box-system-update` runs public sub-steps (`box-os-update`, `box-pkgs-update`, ...) since running just one is a real want. `box-server-setup` runs private sub-steps (`_box-server-power`, ...) since they're one-time toggles, not everyday commands.

Underscore is a hint, not a fence — still on PATH, still runs directly. box-help lists `box-*` only.

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

Script must run on its own, not just via setup.sh. Detect OS with `_box-os-detect`:

```bash
os="$(_box-os-detect)"
```

Dispatch per-OS work on that value (`macos`, `arch`, `fedora`).

## Shared helpers

Cross-script helpers live in `lib/*.sh`, sourced via BOX_ROOT:

```bash
# shellcheck source=/dev/null
. "${BOX_ROOT:-$HOME/box}/lib/<name>.sh"
```

Add a lib only when 2+ scripts share real logic. `lib/run-module.sh` is the current one.

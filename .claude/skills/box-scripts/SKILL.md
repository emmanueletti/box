---
name: box-scripts
description: Conventions for writing box scripts (box-* commands in scripts/.local/bin/box-scripts). Use when creating or editing any box-* script, its comment header, or the box-help contract. Covers the -h/box-help line, the header block box-help parses, and the beginner-first style box uses.
---
# Writing box scripts

box scripts: single bash 5 files in `scripts/.local/bin/box-scripts/`, named `box-<noun>-<action>`. Self-contained, run standalone.

**Audience: beginner reading later, no agent.** Pick simplest pattern that works. Complex pattern only if makes script *simpler overall* — then add short learning comment saying what + why. No cleverness for its own sake.

## Naming: `box-<noun>-<action>`

Noun first = **namespace**, thing command acts on. Action last. Makes `box-<tab>` useful: every zellij command sorts together, find by thing in mind not verb someone picked.

```
box-port-kill        not  box-kill-port
box-history-clear    not  box-clear-history
box-wallpaper-set    not  box-theme-wallpaper
```

Noun with one command today still gets pattern (`box-battery-status`) — gives second command somewhere to land.

No platform in name. `box-server-harden` macOS-only, but script says so by exiting early on other systems — name for thing acted on, not machine ran on. Nouns singular: `box-system-outdated`, not `box-updates-check`. Exception: noun naming collection not one thing, plural *is* subject: `box-scripts-list` lists scripts.

### Verbs

Reach for one of these first, tail stays guessable:

| kind | verbs |
|---|---|
| report | `status` `list` `check` |
| create | `new` `add` |
| destroy | `kill` `clear` `empty` |
| change | `set` `sync` `enable` `harden` |
| invoke | `run` `start` `setup` |

Domain verb only where generic one loses meaning — current full set: `compress` `extract` `copy` `paste` `flush` `relink` `checkout` `restore`. Add reluctantly.

Two namespaces end in object not action, since every command in them does same single thing and object is what varies: `box-random-*` (bytes, password, token, uuid) and `box-date-today`. Prefer over splitting one generator into four one-command namespaces.

Two commands exempt — shadow system verb everyone knows: `box-help` and `box-open`.

## The header block (box-help contract)

box-help builds listing + `-h` output by parsing comment block under shebang. No registration — comment *is* docs. Rules:

- First non-blank comment line = one-line **summary** in `box-help`.
- Bare `#` = blank line in block.
- Indented lines starting with command name = usage detail, shown by `-h`.
- Block ends at first non-comment line (`set -euo pipefail`).

Every script MUST have summary line or `box-help --check` fails.

## Private scripts (`_box-*`)

Leading underscore = "not a command reached for by name". Two kinds qualify: detector whose output exists to be parsed by another script (`_box-os-detect`, `_box-hw-detect`), and narrower variant of public front door (`_box-config-sync` next to `box-system-sync` -- the latter pending a rebuild after the module restructure).

Step of multi-part command qualifies only when wouldn't reach for it alone. Compare two orchestrators:

- `box-system-update` runs `box-os-update`, `box-pkgs-update`, `box-tools-update`, `box-firmware-update` — all public, since updating just packages or just mise tools is everyday want.
- `box-server-setup` runs `_box-server-power`, `_box-server-enable`, `_box-server-autologin` — all private, one-time toggles turning Mac into headless box, not week-to-week commands.

Test: how often step useful alone, not whether it happens to be a step.

Underscore is *hint*, not fence: still sit on PATH, run fine directly. box-help lists `box-*` only — stay out of listing (and `--check`), but `_box-* -h` still prints script's own header.

## The -h line

Right after `set -euo pipefail`, forward `-h` to box-help:

```bash
[[ ${1:-} == -h ]] && exec box-help "$0"
```

Passing `$0` lets box-help print script's own header.

## Template

```bash
#!/usr/bin/env bash
#
# One-line summary -- what it does, shown in the box-help listing.
#
#   box-noun-action <arg>  # detail line, shown by box-help box-noun-action
#   box-noun-action --all  # another mode

set -euo pipefail

[[ ${1:-} == -h ]] && exec box-help "$0"

# ... work here
```

Then `chmod +x`. Scripts dir stow-folded — new file appears on PATH immediately, no re-stow.

## Standalone rule

Script may run on its own, not just via setup.sh. Detect OS with `_box-os-detect` command (sits on PATH alongside other box commands):

```bash
os="$(_box-os-detect)"
```

Per-OS work dispatches on that value (`macos`, `arch`, `fedora`).

## Shared helpers

Cross-script helpers live in `os/lib/*.sh`, sourced (not executed) via BOX_ROOT:

```bash
# shellcheck source=/dev/null
. "${BOX_ROOT:-$HOME/box}/os/lib/<name>.sh"
```

Add lib only when 2+ scripts share real logic. One-off logic stays inline — easier for beginner to follow one file top to bottom. `os/lib/run-module.sh` is the current one (shared by every module's `setup.sh`).

## Style (from CLAUDE.md)

- bash 5. `[[ ]]` for string/file tests, `(( ))` for numbers.
- In `[[ ]]`: don't quote vars; do quote string literals (`[[ $x == "dev" ]]`).
- Prefer `(( count < 50 ))` over `-lt`.
- Quote paths with spaces, don't escape (`"$DIR/My App.app"`).
- ASCII `...` never unicode `…` (breaks `set -u` in non-UTF-8 locales).
- Errors to stderr, prefixed `❌ box-<name>:`. Exit non-zero on real failure.

## Comment style

Terse. Say why, not what code already shows. Comment earns place by teaching beginner something code doesn't show — exit code, gotcha, reason for odd choice:

```bash
checkupdates 2>&1 || rc=$?   # exit 2 == no updates, not an error
```
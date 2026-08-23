---
name: box-scripts
description: Conventions for writing box scripts (box-* commands in platforms/shared/scripts). Use when creating or editing any box-* script, its comment header, or the box-help contract. Covers the -h/box-help line, the header block box-help parses, and the beginner-first style box uses.
---

# Writing box scripts

box scripts are single bash 5 files in `platforms/shared/scripts/.local/scripts/`,
named `box-<noun>-<action>`. Each is self-contained and must run standalone.

**Audience: a beginner reading this later without an agent.** Pick the simplest
pattern that works. Reach for a complex one only when it makes the script
*simpler overall* -- and when you do, add a short learning comment saying what it
does and why. No cleverness for its own sake.

## Naming: `box-<noun>-<action>`

The noun comes first and is the **namespace** -- the thing the command acts on.
The action comes last. This is what makes `box-<tab>` useful: every command that
touches zellij sorts together, so you find one by the thing you have in mind
rather than by remembering the verb someone picked.

```
box-port-kill        not  box-kill-port
box-history-clear    not  box-clear-history
box-wallpaper-set    not  box-theme-wallpaper
```

A noun with one command today still gets the pattern (`box-battery-status`), so
the second one has somewhere to land.

Do not put a platform in the name. `box-server-harden` is macOS-only, but the
script says so by exiting early on other systems -- the name is for the thing it
acts on, not the machine it runs on. Nouns are singular: `box-system-outdated`, not
`box-updates-check`. The exception is a noun that names a collection rather than
one thing, where the plural *is* the subject: `box-scripts-list` lists the
scripts.

### Verbs

Reach for one of these first, so the tail is guessable:

| kind | verbs |
|---|---|
| report | `status` `list` `check` |
| create | `new` `add` |
| destroy | `kill` `clear` `empty` |
| change | `set` `sync` `enable` `harden` |
| invoke | `run` `start` `setup` |

Use a domain verb only where the generic one would lose meaning -- the whole
current set of those is `compress` `extract` `copy` `paste` `flush` `relink`
`checkout` `restore`. Add to that list reluctantly.

Two namespaces end in an object instead of an action, because every command in
them does the same single thing and the object is what varies: `box-random-*`
(bytes, password, token, uuid) and `box-date-today`. Prefer this over splitting
one generator into four one-command namespaces.

Two commands are exempt, because they shadow a system verb everyone already
knows: `box-help` and `box-open`.

## The header block (box-help contract)

box-help builds its listing and `-h` output by parsing the comment block under
the shebang. No registration -- the comment *is* the docs. Rules:

- First non-blank comment line = the one-line **summary** in `box-help`.
- A bare `#` = a blank line in the block.
- Indented lines starting with the command name = usage detail, shown by `-h`.
- The block ends at the first non-comment line (`set -euo pipefail`).

Every script MUST have a summary line or `box-help --check` fails.

## Private scripts (`_box-*`)

A leading underscore means "not a command you reach for by name". Two kinds
qualify: a detector whose output exists to be parsed by another script
(`_box-os-detect`, `_box-hw-detect`), and a narrower variant of a public front
door (`_box-config-sync` next to `box-system-sync`).

A step of a multi-part command qualifies only when you would not reach for it on
its own. Compare the two orchestrators:

- `box-system-update` runs `box-os-update`, `box-pkgs-update`,
  `box-tools-update` and `box-firmware-update` -- all public, because updating
  just your packages or just your mise tools is an everyday thing to want.
- `box-server-setup` runs `_box-server-power`, `_box-server-enable` and
  `_box-server-autologin` -- all private, because they are one-time toggles for
  turning a Mac into a headless box, not commands you use week to week.

The test is how often the step is useful alone, not whether it happens to be a
step.

The underscore is a *hint*, not a fence: these still sit on PATH and run fine
directly. box-help lists `box-*` only, so they stay out of the listing (and out
of `--check`), but `_box-* -h` still prints the script's own header.

## The -h line

Right after `set -euo pipefail`, forward `-h` to box-help:

```bash
[[ ${1:-} == -h ]] && exec box-help "$0"
```

Passing `$0` lets box-help print this script's own header.

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

Then `chmod +x`. The scripts dir is stow-folded, so a new file appears on PATH
immediately -- no re-stow.

## Standalone rule

A script may be run on its own, not just via install.sh. Detect the OS with the
`_box-os-detect` command (it sits on PATH alongside the other box commands):

```bash
os="$(_box-os-detect)"
```

Per-OS work dispatches on that value (`macos`, `arch`, `fedora`).

## Shared helpers

Cross-script helpers live in `lib/*.sh`, sourced (not executed) via BOX_ROOT:

```bash
# shellcheck source=/dev/null
. "${BOX_ROOT:-$HOME/box}/lib/box-check-lib.sh"
```

Add a lib only when 2+ scripts share real logic. One-off logic stays inline --
easier for the beginner to follow one file top to bottom.

## Style (from CLAUDE.md)

- bash 5. `[[ ]]` for string/file tests, `(( ))` for numbers.
- In `[[ ]]`: don't quote vars; do quote string literals (`[[ $x == "dev" ]]`).
- Prefer `(( count < 50 ))` over `-lt`.
- Quote paths with spaces, don't escape (`"$DIR/My App.app"`).
- ASCII `...` never unicode `…` (breaks `set -u` in non-UTF-8 locales).
- Errors to stderr, prefixed `❌ box-<name>:`. Exit non-zero on real failure.

## Comment style

Terse. Say why, not what the code already says. A comment earns its place by
teaching the beginner something the code doesn't show -- an exit code, a gotcha,
a reason for the odd choice:

```bash
box_check_run 2 checkupdates   # exit 2 == no updates, not an error
```

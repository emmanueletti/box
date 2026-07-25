---
name: box-scripts
description: Conventions for writing box scripts (box-* commands in platforms/shared/scripts). Use when creating or editing any box-* script, its comment header, or the box-help contract. Covers the -h/box-help line, the header block box-help parses, and the beginner-first style box uses.
---

# Writing box scripts

box scripts are single bash 5 files in `platforms/shared/scripts/.local/scripts/`,
named `box-<verb>-<noun>`. Each is self-contained and must run standalone.

**Audience: a beginner reading this later without an agent.** Pick the simplest
pattern that works. Reach for a complex one only when it makes the script
*simpler overall* -- and when you do, add a short learning comment saying what it
does and why. No cleverness for its own sake.

## The header block (box-help contract)

box-help builds its listing and `-h` output by parsing the comment block under
the shebang. No registration -- the comment *is* the docs. Rules:

- First non-blank comment line = the one-line **summary** in `box-help`.
- A bare `#` = a blank line in the block.
- Indented lines starting with the command name = usage detail, shown by `-h`.
- The block ends at the first non-comment line (`set -euo pipefail`).

Every script MUST have a summary line or `box-help --check` fails.

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
#   box-thing <arg>        # detail line, shown by box-help box-thing
#   box-thing --all        # another mode

set -euo pipefail

[[ ${1:-} == -h ]] && exec box-help "$0"

# ... work here
```

Then `chmod +x`. The scripts dir is stow-folded, so a new file appears on PATH
immediately -- no re-stow.

## Standalone rule

A script may be run on its own, not just via install.sh. Self-locate BOX_ROOT;
never assume an env var was exported for you:

```bash
os="$("${BOX_ROOT:-$HOME/box}/lib/box-detect-os.sh")"
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

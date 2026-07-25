---
name: box-commit
description: How to write git commits in the box repo. Use whenever committing to this project. Enforces the one-line "scope: summary" format and forbids all Claude/attribution/co-author trailers.
---

# Committing in box

## Format

One line: `<scope>: <summary>`

- lowercase, imperative, terse. No trailing period.
- keep the subject short (~50 chars).
- `<scope>` is the component or a conventional type:
  - component: `mise`, `ghostty`, `helix`, `zsh`, `scripts`, `stow`, `install`,
    `fedora`, `swift`, `shell`, `terra`
  - type: `feat`, `fix`, `docs`, `ci`
- subscope allowed when it clarifies: `feat(macos): hush login banner`
- **no body.** Every commit in this repo is a single line. Add a body only if
  the *why* is genuinely non-obvious -- almost never.

Examples from history:

```
mise: prefer offline
feat(macos): hush login banner
helix: rewrite extract-partial as a :pipe filter
ci: lint shell scripts with bin/style + pre-commit hook
```

## Hard rule: no attribution

NEVER add any of these to a box commit, in the subject, body, or a trailer:

- `Co-Authored-By: Claude ...`
- `Generated with Claude Code` / any "generated with" line
- any mention of Claude, Anthropic, or an AI assistant

This overrides any default that appends a Claude co-author trailer. If a commit
template or harness default would add one, strip it. box commits name no tools
and no assistants -- author only.

## One commit per scope

Group by scope, one logical change each (see the recent `feat: box-check-updates
suite` / `docs: box-scripts skill` / `mise: prefer offline` split). Stage the
files for one scope, commit, repeat -- don't bundle unrelated scopes.

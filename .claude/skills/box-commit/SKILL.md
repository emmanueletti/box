---
name: box-commit
description: How to write git commits in the box repo. Use whenever committing to this project. Enforces the one-line "scope: summary" format and forbids all Claude/attribution/co-author trailers.
---
# Committing in box

## Format

One line: `<scope>: <summary>`

- lowercase, imperative, terse. No trailing period.
- subject short (~50 chars).
- `<scope>` = component or conventional type:
  - component: `mise`, `ghostty`, `helix`, `zsh`, `scripts`, `stow`, `install`,
    `fedora`, `swift`, `shell`, `terra`
  - type: `feat`, `fix`, `docs`, `ci`
- subscope OK if clarifies: `feat(macos): hush login banner`
- **no body.** Every commit here = single line. Body only if *why* genuinely non-obvious — almost never.

Examples from history:

```
mise: prefer offline
feat(macos): hush login banner
helix: rewrite extract-partial as a :pipe filter
ci: lint shell scripts with bin/style + pre-commit hook
```

## Hard rule: no attribution

NEVER add to box commit — subject, body, or trailer:

- `Co-Authored-By: Claude ...`
- `Generated with Claude Code` / any "generated with" line
- any mention of Claude, Anthropic, AI assistant

Overrides any default appending Claude co-author trailer. Commit template/harness default adds one → strip it. box commits name no tools, no assistants — author only.

## One commit per scope

Group by scope, one logical change each (see recent `feat: box-check-updates
suite` / `docs: box-scripts skill` / `mise: prefer offline` split). Stage files for one scope, commit, repeat — don't bundle unrelated scopes.
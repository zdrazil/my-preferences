---
name: code-review
description: "Review changes since a fixed point (commit, branch, tag, or main). Reports what changed, what looks risky, and what's good. Use when the user wants to review a branch, a PR, or asks to 'review since X'."
---

## Process

### 1. Pin the fixed point

Whatever the user specified (commit SHA, branch name, tag, etc.). If they didn't, assume `main` (fall back to `master` if `main` doesn't exist).

Run `git diff <fixed-point>...HEAD` (three-dot, merge-base). Also run `git log <fixed-point>..HEAD --oneline` so you have the commit list.

If the ref doesn't resolve or the diff is empty, tell the user and stop.

### 2. Review the diff

Scan the full diff and your observations across three lenses:

- **What changed** — a brief summary of the scope and intent of the change.
- **Risks** — things that look fragile, incorrect, or worth a second look. Quote only the most relevant snippets.
- **What's good** — things done well, if anything worth calling out.

You may also note style issues or missed refactorings if they're genuinely relevant, but don't force a checklist. Be selective — surface what actually matters, not everything you could possibly comment on.

### 3. Report

Present your findings clearly and concisely. End with a short summary line: total observations across all lenses, and the single most important thing to look at.

If the user mentions a spec or issue, weave those requirements into your review naturally. Don't require a spec — just review the code.

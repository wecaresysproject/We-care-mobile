---
name: flutter-pr
description: Generate a git branch name, commit message, and pull request description based on the current changes. Use when the user requests a PR, commit, submission, push, or is ready to finalize completed work.
allowed-tools: Bash(git *), Bash(gh *)
---

# Git & Pull Request Output

Generate the following after task completion and approval.

## Base Branch (IMPORTANT)
- Always use `main` as the base branch.
- When creating the PR with GitHub CLI:

```bash
gh pr create --base main ...
```
## Branch Name

Use conventional format:

```
fix/<short-description>
feat/<short-description>
refactor/<short-description>
perf/<short-description>
chore/<short-description>
```

Keep it lowercase, hyphen-separated, concise. Example: `feat/user-profile-cache`

## Commit Message

Follow conventional commit format:

```
<type>(<scope>): <short summary>

<optional body — explain why, not what>
```

- Types: `fix`, `feat`, `refactor`, `perf`, `chore`, `test`, `docs`
- Scope: feature or module name (e.g., `auth`, `cart`, `core`)
- Summary: imperative mood, no period, max 72 characters
- Body: only when the "why" isn't obvious from the summary

Examples:
```
feat(auth): add biometric login support

fix(cart): prevent duplicate items when rapidly tapping add button

refactor(core): extract network client into standalone service
```

## Pull Request Title

- Clear, descriptive, concise.
- Match the commit type when possible.
- Example: `feat(auth): Add biometric login support`

## Pull Request Description

Format in markdown. Keep it concise and to the point.

```markdown
## Summary
Brief description of what this PR does and why.

## Changes
- Key change 1
- Key change 2

## Root Cause (bug fixes only)
What caused the bug and how this PR addresses it.

## Testing
How the changes were verified.
```

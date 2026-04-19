---
name: conventional-commits
description: Create focused Git commits using Conventional Commits. Use when Codex is asked to commit work, split changes into meaningful commits, write commit messages, prepare git history, or explain a commit strategy for this repository.
---

# Conventional Commits

Use this workflow whenever committing changes in this repo.

## Workflow

1. Inspect `git status --short` and `git diff --stat`.
2. Split commits by reviewable intent, not by file type.
3. Keep each commit buildable or at least internally coherent.
4. Stage only the files for the current intent.
5. Review staged changes with `git diff --cached --stat` and, when useful, `git diff --cached`.
6. Commit with a Conventional Commit subject.

## Message Format

Use:

```text
type(scope): short imperative summary
```

Prefer these types:

- `feat`: user-visible capability or new repo capability.
- `fix`: bug fix.
- `docs`: documentation-only change.
- `refactor`: behavior-preserving restructuring.
- `chore`: tooling, metadata, repository maintenance.
- `test`: test-only change.
- `ci`: CI workflow change.

Use a scope when it clarifies the area, for example `flake`, `docs`, `agents`, `hosts`, `secrets`, or `templates`.

## Repo Strategy

For this Nix dotfiles repo, `main` should represent an evaluated, recoverable setup. Prefer commits that pass `nix flake check` before pushing to `main`. If Nix is unavailable locally, say that clearly in the final response and keep the commit coherent enough to validate later.

Use feature branches for risky host changes, disk changes, secret wiring, bootloader changes, and broad refactors. Small docs and scaffold updates may go directly to `main` if they are reviewed and coherent.

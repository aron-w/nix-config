# AI Workflow

The repo uses durable documentation plus a thin `AGENTS.md`.

`AGENTS.md` exists because many coding agents discover it automatically. The long-lived source of truth should stay in `docs/` so the project remains usable across Codex, Cursor, Copilot, local scripts, and future tools.

## Agent Expectations

- Read `docs/decisions.md` before changing structure.
- Read `docs/hosts.md` before adding host outputs.
- Prefer small, reviewable changes.
- Validate with `nix fmt` and `nix flake check` when Nix is available.
- Never invent host facts, usernames, SSH keys, disks, or secrets.

## Prompting Pattern

Good future requests should include:

- Target host or module.
- Desired behavior.
- Whether the change is system-wide or user-level.
- Any required package channel, such as stable or unstable.
- Any secrets involved, without pasting the secret value.

## Review Checklist

- Does the change keep host-specific facts inside `hosts/<name>/`?
- Does reusable behavior live under `nix/modules/`?
- Are unstable packages explicit?
- Are secrets encrypted or documented as intentionally absent?
- Do docs and commands still match the implementation?

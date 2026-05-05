# AI Workflow

The repo uses durable documentation plus a thin `AGENTS.md`.

`AGENTS.md` exists because many coding agents discover it automatically. The long-lived source of truth should stay in `docs/` so the project remains usable across Codex, Cursor, Copilot, local scripts, and future tools.

For token efficiency, agents should treat `AGENTS.md` as the routing layer and `docs/agent-index.md` as the compact repo map. Deeper docs are task-specific and should be read only when the change routes there.

## Agent Expectations

- Prefer small, reviewable changes.
- Use the `conventional-commits` skill when the user asks for commits, history preparation, or publishing.
- Split requested commits by reviewable intent so rollback, review, and `git bisect` stay practical.
- Match verification to the risk and scope described in `AGENTS.md` and `docs/verification.md`.
- Never invent host facts, usernames, SSH keys, disks, or secrets.

## Prompting Pattern

Good future requests should include:

- Target host or module.
- Desired behavior.
- Whether the change is system-wide or user-level.
- Any required package channel, such as stable or unstable.
- Any secrets involved, without pasting the secret value.

## Review Checklist

- Does the change keep host-specific facts inside `modules/hosts/<name>/`?
- Is every active `.nix` file under `modules/` a top-level `flake-parts` module?
- Does reusable behavior live under `modules/features/` or another concern-based `modules/` subtree?
- Are unstable packages explicit?
- Are secrets encrypted or documented as intentionally absent?
- Do docs and commands still match the implementation?
- If commits were requested, is each commit cohesive, reviewable, and named with a Conventional Commit subject?

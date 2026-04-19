# Secrets

Secrets are managed with `sops-nix` and `age`.

## Rules

- Never commit plaintext secrets.
- Never commit generated age identity private keys.
- Encrypted SOPS files may live under `secrets/`.
- Modules should reference decrypted secret paths exposed by `sops-nix`, not hard-coded secret values.
- Keep host and user access explicit in SOPS recipient rules.

## Initial Setup Later

When the first real host is added:

1. Generate or select an age identity for the host.
2. Add a `.sops.yaml` with recipient rules.
3. Create encrypted secret files with `sops`.
4. Import `sops-nix.nixosModules.sops` in the host configuration.
5. Add only encrypted files to git.

## Do Not Store

- Passwords in Nix strings.
- API tokens.
- SSH private keys.
- WireGuard private keys.
- OAuth client secrets.
- Work credentials.

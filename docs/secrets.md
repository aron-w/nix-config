# Secrets

Secrets are managed with `sops-nix` and `age`.

## Rules

- Never commit plaintext secrets.
- Never commit generated age identity private keys.
- Encrypted SOPS files may live under `secrets/`.
- Modules should reference decrypted secret paths exposed by `sops-nix`, not hard-coded secret values.
- Keep host and user access explicit in SOPS recipient rules.

## Adding Secrets

SOPS is already integrated through `modules/nix/sops.nix`, and `dominus` composes that integration through its host output. When adding real secrets:

1. Generate or select an age identity for the host.
2. Add a `.sops.yaml` with recipient rules.
3. Create encrypted secret files with `sops`.
4. Reference decrypted paths through `sops.secrets.<name>`.
5. Add only encrypted files to git.

## 1Password And SSH Keys

1Password SSH keys are good for personal authentication: SSH into machines, sign Git commits, and access GitHub. They do not replace machine secrets that services need during boot.

For NixOS services, prefer `sops-nix` with an age recipient for each host. A backup copy of the host age identity may live in 1Password, but the machine needs a local private key at activation time.

`dominus` is wired to use its host SSH key as an age identity source:

```text
/etc/ssh/ssh_host_ed25519_key
```

After the host exists, derive its age public recipient:

```sh
ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub
```

## Do Not Store

- Passwords in Nix strings.
- API tokens.
- SSH private keys.
- WireGuard private keys.
- OAuth client secrets.
- Work credentials.

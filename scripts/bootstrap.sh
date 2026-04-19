#!/usr/bin/env bash
set -euo pipefail

repo_url="https://github.com/aron-w/nix-config.git"
checkout_dir="${HOME}/src/nixos-config"
host="dominus"
mode="auto"
assume_yes=0
wipes_disk=0

usage() {
  cat <<'USAGE'
Usage:
  bootstrap [--host dominus] [--checkout-dir PATH] [--repo-url URL] [--mode auto|auth|check|switch|test|dev|install] [--yes]

Modes:
  auto     Clone/update the repo, check the flake, switch on NixOS, otherwise prepare the dev shell.
  auth     First-login helper: finish 1Password SSH agent setup and switch this repo to SSH.
  check    Clone/update the repo and run nix flake check.
  switch   Run sudo nixos-rebuild switch --flake .#HOST.
  test     Run sudo nixos-rebuild test --flake .#HOST.
  dev      Clone/update the repo and realise the dev shell.
  install  From the NixOS installer only: run Disko, nixos-install, and prompt for the user password.

Destructive install mode requires:
  --i-understand-this-wipes-the-disk
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --host)
      host="$2"
      shift 2
      ;;
    --checkout-dir)
      checkout_dir="$2"
      shift 2
      ;;
    --repo-url)
      repo_url="$2"
      shift 2
      ;;
    --mode)
      mode="$2"
      shift 2
      ;;
    --yes|-y)
      assume_yes=1
      shift
      ;;
    --i-understand-this-wipes-the-disk)
      wipes_disk=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

case "$mode" in
  auto|auth|check|switch|test|dev|install) ;;
  *)
    echo "Unsupported mode: $mode" >&2
    usage >&2
    exit 2
    ;;
esac

if ! command -v nix >/dev/null 2>&1; then
  cat >&2 <<'MSG'
Nix is not installed or not on PATH.

Install Nix first, then rerun this bootstrap command.
Recommended for Linux and WSL:
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
MSG
  exit 1
fi

nix_cmd=(nix --extra-experimental-features "nix-command flakes")

confirm() {
  if [ "$assume_yes" -eq 1 ]; then
    return 0
  fi

  printf "%s [y/N] " "$1"
  read -r reply
  case "$reply" in
    y|Y|yes|YES) ;;
    *) echo "Aborted."; exit 1 ;;
  esac
}

clone_or_update() {
  mkdir -p "$(dirname "$checkout_dir")"

  if [ -d "$checkout_dir/.git" ]; then
    echo "Updating $checkout_dir"
    git -C "$checkout_dir" fetch origin
    git -C "$checkout_dir" pull --ff-only
  elif [ -e "$checkout_dir" ]; then
    echo "Checkout path exists but is not a Git repo: $checkout_dir" >&2
    exit 1
  else
    echo "Cloning $repo_url to $checkout_dir"
    git clone "$repo_url" "$checkout_dir"
  fi
}

flake_ref() {
  printf "%s#%s" "$checkout_dir" "$host"
}

is_nixos() {
  [ -e /etc/NIXOS ]
}

is_nixos_installer() {
  grep -qi "installer" /etc/os-release 2>/dev/null || [ -e /iso ]
}

run_check() {
  echo "Checking flake"
  "${nix_cmd[@]}" flake check "$checkout_dir"
}

run_dev() {
  echo "Preparing dev shell"
  "${nix_cmd[@]}" develop "$checkout_dir" --command true
}

run_rebuild() {
  local action="$1"

  if ! is_nixos; then
    echo "This is not NixOS; cannot run nixos-rebuild $action." >&2
    exit 1
  fi

  echo "Running nixos-rebuild $action for $host"
  sudo nixos-rebuild "$action" --flake "$(flake_ref)"
}

run_install() {
  if [ "$wipes_disk" -ne 1 ]; then
    cat >&2 <<'MSG'
Install mode is destructive because it runs Disko.
Rerun with --i-understand-this-wipes-the-disk after verifying the target disk.
MSG
    exit 1
  fi

  if ! is_nixos_installer; then
    confirm "This does not look like the NixOS installer. Continue anyway?"
  fi

  confirm "Disko will wipe and repartition the configured target disk. Continue?"

  echo "Running Disko for $host"
  sudo "${nix_cmd[@]}" run github:nix-community/disko/latest -- --mode disko --flake "$(flake_ref)"

  echo "Installing NixOS for $host"
  sudo nixos-install --flake "$(flake_ref)"

  echo "Set the local password for aron before rebooting."
  sudo nixos-enter --root /mnt -c "passwd aron"
}

run_auth() {
  cat <<'MSG'
Finish 1Password SSH setup:

1. Open 1Password and sign in.
2. Go to Settings > Developer.
3. Turn on "Use the SSH agent".
4. Keep 1Password unlocked while this script tests GitHub SSH.
MSG

  if command -v 1password >/dev/null 2>&1; then
    echo "Opening 1Password"
    1password >/dev/null 2>&1 &
  fi

  echo "Waiting for ~/.1password/agent.sock"
  for _ in $(seq 1 90); do
    if [ -S "$HOME/.1password/agent.sock" ]; then
      break
    fi
    sleep 2
  done

  if [ ! -S "$HOME/.1password/agent.sock" ]; then
    cat >&2 <<'MSG'
Could not find ~/.1password/agent.sock.
Enable the 1Password SSH agent in the 1Password GUI, then rerun:
  nix run github:aron-w/nix-config#bootstrap -- --mode auth
MSG
    exit 1
  fi

  echo "Testing GitHub SSH. Approve the 1Password prompt when it appears."
  set +e
  ssh -T -o StrictHostKeyChecking=accept-new git@github.com
  ssh_status="$?"
  set -e

  if [ "$ssh_status" -gt 1 ]; then
    echo "GitHub SSH test failed with exit code $ssh_status." >&2
    exit "$ssh_status"
  fi

  echo "Switching repo remote to SSH"
  git -C "$checkout_dir" remote set-url origin "git@github.com:aron-w/nix-config.git"
  git -C "$checkout_dir" remote -v
}

clone_or_update

case "$mode" in
  auth)
    run_auth
    ;;
  check)
    run_check
    ;;
  dev)
    run_check
    run_dev
    ;;
  test)
    run_check
    run_rebuild test
    ;;
  switch)
    run_check
    run_rebuild switch
    ;;
  install)
    run_check
    run_install
    ;;
  auto)
    run_check
    if is_nixos; then
      run_rebuild switch
    else
      run_dev
    fi
    ;;
esac

echo "Done."

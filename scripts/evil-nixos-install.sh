#!/usr/bin/env bash
set -euo pipefail

REMOTE_HOST=
NIXOS_CONFIG=
NIXOS_INSTALL_CMD=

function usage() {
    echo "Usage: $0 [-h] [-r REMOTE_HOST] [-c NIXOS_CONFIG]"
}

while getopts ":hr:c:" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        r)
            REMOTE_HOST=$OPTARG
            ;;
        c)
            NIXOS_CONFIG=$OPTARG
            ;;
        :)
            echo "Option -${OPTARG} requires an argument." >&2
            exit 1
            ;;
        ?)
            echo "Invalid option: -${OPTARG}" >&2
            exit 1
            ;;
    esac
done

if [ -z "$NIXOS_CONFIG" ]; then
    echo "Error: missing required argument -c" >&2
    usage
    exit 1
fi

if [ -z "$REMOTE_HOST" ]; then
    NIX_INSTALL_CMD="sudo nixos-install --no-root-password --flake .#${NIXOS_CONFIG}"
    
else
    NIX_INSTALL_CMD="nix run github:nix-community/nixos-anywhere -- \
    --flake .#${NIXOS_CONFIG}-bootstrap -i ~/.ssh/id_ed25519.pub \
    root@${REMOTE_HOST}"
fi

$NIX_INSTALL_CMD

echo "Script finished"
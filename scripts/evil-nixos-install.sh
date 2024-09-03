#!/usr/bin/env bash
set -euo pipefail

REMOTE_HOST=
NIXOS_CONFIG=
NIXOS_INSTALL_CMD=
SSH_KEY_PATH=
TMP_DIR=

function usage() {
    echo "Usage: $0 [-h] [-r REMOTE_HOST] -d SSH_KEY_PATH -c NIXOS_CONFIG"
}

while getopts ":hr:c:d:" opt; do
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
        d)
            SSH_KEY_PATH=$OPTARG
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

if [ -z "$SSH_KEY_PATH" ]; then
    echo "Error: missing required argument -d" >&2
    usage
    exit 1
fi

if [ -z "$REMOTE_HOST" ]; then
    NIX_INSTALL_CMD="sudo nixos-install --no-root-password --flake .#${NIXOS_CONFIG}"
    
else
    NIX_INSTALL_CMD="nix run github:nix-community/nixos-anywhere -- \
    --flake .#${NIXOS_CONFIG}  \
    --extra-files ${SSH_KEY_PATH} \
    root@${REMOTE_HOST}"
fi

$NIX_INSTALL_CMD

echo "Script finished"
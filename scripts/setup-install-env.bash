if [[ ! -e ./evilwoods-nixos-config/.git ]]; then
    git clone --depth 1 git@github.com:sttagent/evilwoods-nixos-config.git || {
        echo "ERROR: failed to clone evilwoods-nixos-config repo."
        exit 1
    }
else
    echo "INFO: local copy of evilwoods-nixos-config repo already exists."
    exit
fi

if [[ ! -e ./evilwoods-nixos-config-secrets/.git ]]; then
    git clone --depth 1 git@github.com:sttagent/evilwoods-nixos-config-secrets.git || {
        echo "ERROR: failed to clone evilwoods-nixos-config-secrets repo."
        exit 1
    }
else
    echo "INFO: local copy of evilwoods-nixos-config repo already exists."
    exit
fi

cd evilwoods-nixos-config

exec nix-shell

default:
    just --list

update-inputs:
    nix flake update --commit-lock-file

os *FLAGS:
    ./scripts/evilnixos {{FLAGS}}

run-tests-interactive host:
    sudo sh -c "LD_LIBRARY_PATH= nix run -L .#packages.x86_64-linux.{{host}}-test.driverInteractive --option sandbox false"

run-tests host:
    sudo sh -c "LD_LIBRARY_PATH= nix run -L .#packages.x86_64-linux.{{host}}-test --option sandbox false"

save-age-key username password:
    #!/usr/bin/env bash
    mkdir -p ~/.config/sops/age/
    touch ~/.config/sops/age/keys.txt
    session_key=$(bw login {{username}} {{password}} --raw)
    bw get password evilwoods-nixos-sops --session "$session_key" | tee ~/.config/sops/age/keys.txt

install-nixos host:
    sudo nixos-install --no-root-password --flake .#{{host}}

config-env:
    #!/usr/bin/env bash
    echo | tee ~/.ssh/config <<- EndOfMessage
    Host *
        IdentitiesOnly yes
        IdentityAgent none
        IdentityFile ~/.ssh/id_ed25519_sk_rk_yubikey2
    EndOfMessage
    git config --global user.name "Arvydas Ramanauskas"
    git config --global user.email "711261+sttagent@users.noreply.github.com"

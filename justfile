default:
    just --list

update-inputs *INPUTS:
    nix flake update --commit-lock-file {{INPUTS}}

disko mode config:
    nix run github:nix-community/disko/latest -- --mode {{mode}} --flake .#{{config}}

install-nixos config:
    nixos-install --no-root-password --flake .#{{config}}

get-hardwase-config *ROOT:
    nixos-generate-config --show-hardware-config --no-filesystems {{ROOT}}

osctl *FLAGS:
    python ./scripts/evilosctl {{FLAGS}}

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

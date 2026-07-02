default:
    just --list

update-inputs *INPUTS:
    nix flake update --commit-lock-file {{ INPUTS }}

disko-mount config:
    nix run github:nix-community/disko/latest -- --mode mount --flake .#{{ config }}

disko-format config:
    nix run github:nix-community/disko/latest -- --mode destroy,format,mount --flake .#{{ config }}

diff-remote-host remote-host:
    nix copy -s $(realpath ./result/) --to ssh://{{ remote-host }}
    ssh {{ remote-host }} "nix run nixpkgs#nvd diff /run/current-system $(realpath ./result/)"

install-nixos-local config:
    nixos-install \
        --no-root-password \
        --option extra-substituters https://install.determinate.systems \
        --option extra-trusted-public-keys cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= \
        --flake .#{{ config }}

install-nixos-remote config remote-host extra-files:
    nix run github:nix-community/nixos-anywhere -- \
        --flake .#{{ config }} \
        --extra-files {{ extra-files }} \
        --option extra-substituters https://install.determinate.systems \
        --option extra-trusted-public-keys cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM= \
        --target-host {{ remote-host }}

get-hardwase-config *ROOT:
    nixos-generate-config --show-hardware-config --no-filesystems {{ ROOT }}

osctl *FLAGS:
    python ./scripts/evilosctl {{ FLAGS }}

run-tests-interactive host:
    sudo sh -c "LD_LIBRARY_PATH= nix run -L .#packages.x86_64-linux.{{ host }}-test.driverInteractive --option sandbox false"

run-tests host:
    sudo sh -c "LD_LIBRARY_PATH= nix run -L .#packages.x86_64-linux.{{ host }}-test --option sandbox false"

save-age-key username password:
    #!/usr/bin/env bash
    mkdir -p ~/.config/sops/age/
    touch ~/.config/sops/age/keys.txt
    session_key=$(bw login {{ username }} {{ password }} --raw)
    bw get password evilwoods-nixos-sops --session "$session_key" | tee ~/.config/sops/age/keys.txt

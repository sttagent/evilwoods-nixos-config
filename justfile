default:
    just --list

check:
    nix flake check
update *INPUTS:
    nix flake update --commit-lock-file {{ INPUTS }}

# local build commands
build:
    nix run .#$(hostname)
test:
    nix run .#$(hostname) -- test -a
switch:
    nix run .#$(hostname) -- switch -a
boot:
    nix run .#$(hostname) -- boot -a
reboot:
    nix run .#$(hostname) -- boot -a && sleep 3 && systemctl reboot

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

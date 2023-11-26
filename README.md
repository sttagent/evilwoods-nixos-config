### Commands to install NixOS from flake
sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko ./evilroots-partition-scheme.nix

sudo nixos-install --no-root-password --flake .#evilroots

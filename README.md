### Commands to install NixOS from flake
```bash
# format and partrition the drive
sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake github:sttagent/evilwoods-nixos-config#<host>

# install nixos from flake
sudo nixos-install --no-root-password --flake github:sttagent/evilwoods-nixos-config#<host>
```

### Commands to install NixOS from flake
#### format and partrition the drive
```bash
sudo nix --extra-experimental-features 'nix-command flakes' run github:nix-community/disko -- --mode disko --flake github:sttagent/evilwoods-nixos-config#<host>
```

#### install nixos from flake
```bash
sudo nixos-install --no-root-password --flake github:sttagent/evilwoods-nixos-config#<host>
```

### Notes
```bash
git -c core.sshCommand='ssh -o StrictHostKeyChecking=accept-new' clone ...
```
```
```

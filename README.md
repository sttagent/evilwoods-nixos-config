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
#### Clone git repo using residential keys
```bash
[nixos@nixos:~]$ git -c core.sshCommand='ssh -o StrictHostKeyChecking=accept-new -o IdentityAgent=none -i .ssh/id_ed25519_sk_rk_yubikey2' clone git@github.com:sttagent/evilwoods-nixos-config.git

```

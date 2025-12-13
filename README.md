# Evilwoods NixOS Config

This is my personal very much work in progress NixOS configuration.

## Folder Structure

### dotfiles

Various configuration files managed by home-manager I was not able to configure through home-manager module system.

### hosts

NixOS system configuration folder.

hosts:

- `evilbook` - laptop
- `evilserver` - home server (currently not used)
- `evilcloud` - server

### lib

Nix functions written for this configuration.

### overlays

Custom overlays

### packages

Custom packages not packaged in nixpkgs

### scripts

Various helper scripts specific to this configuration.

### users

User creation and configuration. Managed by home-manager.

## Notes

### Installation notes
hardware
- clone repositories and enter install env.

```bash
nix run github.com/sttagent/evilwoods-nixos-config#install_env
```
- format disks
```bash
just disko mode nixosConfig
```
- install nixos config
```bash
just install-nixos nixosConfig
```

- Setup host ssh keys.
  - Generate new ones with the script in secrets repo or point to old ones
  - Update re-encrypt sops secrets
- Install nixos using the script in the config repo

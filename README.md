# Evilwoods NixOS Config

This is my personal, work in progress NixOS configuration.

## Folder Structure

### dotfiles

Various configuration files managed by home-manager I was not able to configure through home-manager module system.

### hosts

NixOS system configuration folder.

hosts:

- `evilbook` - laptop
- `rynepc` - desktop
- `evilnas` - local server
- `evilcloud` - remote server

### lib

Nix helper functions specific to this configuration.

### overlays

Custom overlays

### packages

Custom packages not packaged in nixpkgs

### scripts

Various helper scripts specific to this configuration.

### users

User creation and configuration. User confguration Managed by home-manager.

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

# Evilwoods NixOS Config

My family's computers and homelab, managed with NixOS flakes.

## The Machines

| Host | What | Desktop |
|------|------|---------|
| evilbook | laptop | Cosmic |
| rynepc | desktop | GNOME |
| evilcloud | remote server | - |

## Quick Start

```bash
# dev shell
nix develop

# build
just osctl build [host]

# apply
just osctl switch [host]
```

## Structure

Everything lives in `modules/`:

- `hosts/` - per-machine configs
- `hosts/common/` - shared base, desktop, hardware modules
- `users/` - home-manager configs per user

Other stuff:
- `dotfiles/` - config files home-manager can't handle
- `scripts/` - helper scripts and evilosctl CLI

## Fresh Install

```bash
nix develop .#install_env
just disko-format nixosConfig
just install-nixos nixosConfig
```

## Notes

- Uses flake-parts + import-tree for module discovery
- Unstable channel for workstations, stable (25.11) for server
- Secrets via sops-nix in a separate private repo

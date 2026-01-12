# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal NixOS flake-based configuration managing multiple hosts (laptop, desktop, local server, remote server) with home-manager integration. The configuration uses a custom library (`evilib`) for automatic host discovery and configuration generation.

## Development Environment

Enter the development shell:
```bash
nix develop
```

The dev shell includes: nixd, nix-output-monitor, nvd, nixfmt, jq, python3 with questionary, basedpyright, ruff, lua-language-server, nixos-option, nix-tree, statix.

For installation tasks, use the install environment:
```bash
nix develop .#install_env
```

## Common Commands

### Building and Deploying

Using `just` (recommended):
```bash
# List all available commands
just

# Build a configuration (uses evilosctl wrapper with interactive prompts)
just osctl build [nixosConfig]

# Switch to a new configuration
just osctl switch [nixosConfig]

# Test a configuration
just osctl test [nixosConfig]

# Boot to a new configuration
just osctl boot [nixosConfig]
```

Using `evilosctl` directly (Python/xonsh wrapper in scripts/):
```bash
# Build with optional diff
python ./scripts/evilosctl build [--diff] [-t target-host] [nixos_config]

# Switch configuration
python ./scripts/evilosctl switch [--diff] [-t target-host] [nixos_config]

# Test configuration
python ./scripts/evilosctl test [-t target-host] [nixos_config]

# Boot to configuration
python ./scripts/evilosctl boot [--reboot] [-t target-host] [nixos_config]

# Diff with current system
python ./scripts/evilosctl diff [-t target-host] [nixos_config]
```

If `nixos_config` is not provided, evilosctl will prompt with an interactive selection menu.

### Installation

```bash
# Format disks (WARNING: destructive)
just disko-format nixosConfig

# Mount disks only
just disko-mount nixosConfig

# Install NixOS
just install-nixos nixosConfig

# Generate hardware config
just get-hardwase-config [--root /mnt]
```

### Maintenance

```bash
# Update all flake inputs
just update-inputs

# Update specific inputs
just update-inputs input1 input2

# Format Nix files
nixfmt .
```

### Testing

```bash
# Run interactive VM test
just run-tests-interactive hostName

# Run automated VM test
just run-tests hostName
```

## Architecture

### Host Discovery and Generation

The core architecture uses `lib/default.nix` (`evilib`) to automatically discover and generate NixOS configurations:

1. **Host Discovery**: `findAllHosts` scans `hosts/` for `.toml` files
2. **Host Metadata**: Each host has a `<hostname>.toml` file defining:
   - `system`: Platform architecture (e.g., "x86_64-linux")
   - `channel`: nixpkgs channel ("nixkpgs-25-11" or "nixpkgs-unstable")
   - `mainUser`: Primary user name
   - `extraUsers`: Additional users (list)
   - `makeTestHost`: Whether to generate a VM test variant
3. **Configuration Assembly**: `mkHost` builds each NixOS configuration by composing:
   - Common modules from `modules/`
   - Host-type modules from `hosts/common/{base,desktop,server,hardware}/`
   - User modules from `users/common/` and `users/<user>-<host>/`
   - Host-specific modules from `hosts/<hostname>/`

### Directory Structure

- **hosts/**: Per-host NixOS system configurations
  - `<hostname>/<hostname>.toml`: Host metadata
  - `<hostname>/configuration.nix`, `hardware.nix`, etc.: Host-specific configs
  - `common/base/`: Base system configuration (all hosts)
  - `common/desktop/`: Desktop environment configs (GNOME, KDE)
  - `common/server/`: Server-specific configs
  - `common/hardware/`: Hardware-specific configs (AMD, Intel, NVIDIA)
  - `config/`: Shared configuration files referenced by hosts

- **users/**: User creation and home-manager configurations
  - `<username>/`: User-wide configuration (all hosts)
  - `<username>-<hostname>/`: Per-host user configuration
  - `common/`: Configuration applied to all users

- **lib/**: Custom helper functions
  - `mkHosts`: Discovers hosts and generates nixosConfigurations
  - `mkImportList`: Recursively imports .nix files (excluding default.nix, test.nix)
  - `mkUserImportList`: Like mkImportList but passes username to imports
  - `readInVarFile`: Reads TOML configuration files

- **modules/**: Custom NixOS modules (e.g., rsync-backup.nix)

- **packages/**: Custom packages not in nixpkgs (xonsh-direnv, xontrib-fish-completer)

- **overlays/**: Package overlays (pythonPackages.nix)

- **dotfiles/**: Configuration files managed by home-manager but not configurable through modules

- **scripts/**: Helper scripts
  - `evilosctl/`: Python CLI wrapper for nixos-rebuild with interactive prompts
  - `main.xsh`: Main xonsh script for building/deploying

- **archive/**: Deprecated/old configurations

### Special Args Available in Modules

Modules have access to these special arguments:
- `inputs`: Flake inputs
- `evilib`: Custom library functions from `lib/default.nix`
- `configPath`: Path to `hosts/config/` (shared configs)
- `dotFilesPath`: Path to `dotfiles/`
- `resourcesPath`: Path to `resources/`

### Dual Channel Support

The flake defines both stable (25.11) and unstable channels:
- Each host specifies its channel in `<hostname>.toml`
- Home-manager, disko, and sops-nix track the chosen nixpkgs channel
- Allows mixing stable servers with bleeding-edge workstations

### Secrets Management

Uses sops-nix with age encryption:
- Secrets stored in separate private repo: `evilwoods-nixos-config-secrets`
- Age keys derived from SSH host keys
- Generate new host keys: `just osctl gen-host-keys nixosConfig --secrets-path ../evilwoods-nixos-config-secrets`

### Active Hosts

- `evilbook`: Laptop (unstable channel)
- `rynepc`: Desktop (unstable channel)
- `evilnas`: Local server
- `evilcloud`: Remote server

## Formatting

Format Nix files with:
```bash
nixfmt <file>
```

Or format entire project:
```bash
nixfmt .
```

## MCP Integration

This repository includes `.mcp.json` for Model Context Protocol integration with NixOS package/option search capabilities.

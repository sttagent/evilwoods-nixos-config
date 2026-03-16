# Evilwoods NixOS Config - Agent Guidelines

## Build Commands

```bash
# Enter development shell
nix develop

# List available commands
just

# Build configuration
just osctl build [host]

# Switch to new configuration
just osctl switch [host]

# Test configuration (dry-run)
just osctl test [host]

# Build VM for testing
just osctl build-vm [host]

# Update flake inputs
just update-inputs [input-name]

# Run NixOS VM tests
just run-tests <host>
just run-tests-interactive <host>
```

## Code Style

### Nix Language
- **Indentation**: 2 spaces (no tabs)
- **Line length**: ~100 characters soft limit
- **Formatting**: Use `nixfmt` if available, otherwise follow existing patterns
- **Function arguments**: Prefer `inherit (lib) mkOption types` pattern
- **Pipe operators**: Use experimental pipe operators `|>` where appropriate

### Module Structure
```nix
{ inputs, ... }:
{
  flake.modules.nixos.hostName =
    { config, pkgs, ... }:
    let
      inherit (config.evilwoods.variables) mainUser;
    in
    {
      # Module body
    };
}
```

### Naming Conventions
- **Hosts**: PascalCase with "host" prefix (e.g., `hostRynepc`, `hostEvilbook`)
- **Users**: camelCase with "user" prefix (e.g., `userAitvaras`)
- **Options**: Under `evilwoods` namespace
- **Files**: lowercase-with-dashes.nix

### Imports and Dependencies
- Use `inherit (lib) function1 function2` for multiple imports
- Prefer `let ... in` blocks for local variables
- Use `mkDefault` for values that should be overrideable
- Use `mkIf` for conditional configuration

## Project Structure

```
modules/
├── hosts/           # Per-machine NixOS configs
│   ├── common/      # Shared base, desktop, server, hardware
│   ├── evilbook/    # Laptop with Cosmic
│   ├── rynepc/      # Desktop with GNOME
│   └── evilcloud/   # Remote server
├── users/           # Home-manager configs
│   ├── aitvaras/    # User module base
│   ├── aitvaras@host/  # Host-specific user configs
│   └── ryne/
├── flake-parts.nix  # Flake configuration
└── devShells/       # Development shells

scripts/evilosctl/   # Python CLI tool
├── __main__.py      # CLI entry point
├── models.py        # Data models
└── utils.py         # Utilities

dotfiles/            # Config files for home-manager
resources/           # Static resources
```

## Python (evilosctl)

- **Style**: PEP 8 compliant
- **Type hints**: Required for function signatures
- **Imports**: Standard library first, then third-party, then local
- **Error handling**: Use explicit error types, avoid bare `except:`

## Secrets Management

- Use `sops-nix` for encrypted secrets
- Secrets stored in separate private repo (`evilsecrets` input)
- Never commit plaintext secrets
- Use `config.sops.secrets.<name>.path` to access

## Testing

- NixOS VM tests defined per-host
- Run with `just run-tests <host>`
- Interactive testing with `just run-tests-interactive <host>`

## Git Workflow

- Commit messages: Imperative mood ("Add feature" not "Added feature")
- Lock file updates: `just update-inputs` commits automatically
- Git identity configured in `shell.nix` for consistent commits

## Common Tasks

```bash
# Fresh install workflow
nix develop .#install_env
just disko-format <config>
just install-nixos <config>

# Format disk for new install
just disko-mount <config>

# Get hardware config
just get-hardwase-config [root-mount]
```

## Important Notes

- Uses experimental Nix features: flakes, nix-command, pipe-operators
- Unstable channel for workstations, stable (25.11) for servers
- FlakeHub used for some inputs
- Cachix configured for faster builds
- Uses **flake-parts** framework with `import-tree` for automatic module discovery

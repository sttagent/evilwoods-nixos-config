# Repository Guidelines

## Project Structure & Module Organization

This repository is a Nix flake for NixOS systems and user environments. The main configuration is under `modules/`: hosts in `modules/hosts/`, users in `modules/users/`, shared schemas/defaults in `modules/shared/`, and flake outputs in top-level module files. Machine- and user-specific files are grouped by name, such as `modules/hosts/evilbook/` and `modules/users/aitvaras/`. Managed application configuration is in `dotfiles/`; Bash scripts are in `scripts/`; the Python `evilosctl` utility is in `scripts/evilosctl/`; packaged Python code is in `packages/evilwoods-update/`; and assets are in `resources/`. Secrets come from the separate `evilwoods-nixos-config-secrets` input and must not be committed here.

## Build, Test, and Development Commands

Just commands are currently unused. Enter the pinned development environment with `direnv allow` (after reviewing `.envrc`) or `nix-shell`:

- `nix flake check` — evaluate flake outputs and run available checks.
- `just` — list repository recipes.
- `just update <input>` — update selected flake inputs and commit the lockfile change.

For a local build, use `nixos-rebuild build --flake .#<host>` and inspect the output before switching.

## Coding Style & Naming Conventions

Use two-space indentation for Nix and Bash, and four spaces for Python. Keep Nix attributes and module filenames lowercase, using hyphens where appropriate; use descriptive host/user directory names. Python modules/functions use `snake_case`; Bash variables use uppercase `SNAKE_CASE`. Preserve generated-file markers in `flake.nix`; regenerate it with `nix run .#write-flake`. Keep changes focused.

## Testing Guidelines

There is no standalone unit-test suite. Validate Nix changes with `nix flake check` and, when behavior affects a machine, `just run-tests <host>`. Use the exact flake host name. For Python or Bash changes, run the relevant command locally and check failures carefully.

## Commit & Pull Request Guidelines

Recent commits use short, imperative, lowercase summaries such as `fix rynepc channel` and `update noctalia config`; follow that style and keep commits focused. Pull requests should explain affected hosts/users, list validation commands and results, call out lockfile or configuration impacts, and include screenshots for visible desktop changes. Never include secrets or credentials.

## Security & Configuration Tips

Review hostnames, SSH targets, certificate paths, and privilege-changing commands before running recipes. Treat `sops`, `age`, remote installs, and disk-format recipes as sensitive; verify the target host and flake attribute first.

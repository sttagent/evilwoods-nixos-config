# Repository Guidelines

## Project Structure & Module Organization

This is a Nix flake for several NixOS machines. `flake.nix` is generated from the dendritic configuration in `modules/`; edit modules and regenerate the flake instead of editing it directly. Host definitions live under `modules/hosts/<hostname>/`, user configuration under `modules/users/<name>/`, and reusable features under `modules/aspects/`. Shared schemas and policies are in `modules/schema/` and `modules/policies/`. Application configuration belongs in `dotfiles/`, helper programs in `packages/`, scripts in `scripts/`, and static files in `resources/`. Treat `archive/` as historical code unless explicitly targeted.

## Build, Test, and Development Commands

Enter the pinned development environment with `nix develop` (or allow direnv via `direnv allow`). Common commands are:

- `just check`: run all flake checks before submitting changes.
- `just build`: build the configuration matching the current hostname.
- `just test`: activate that configuration in NixOS test mode without making it the boot default.
- `just switch`: build and activate the local host configuration.
- `just update [INPUT...]`: update all or selected flake inputs and commit the lock-file change.
- `nix build .#nixosConfigurations.evilbook.config.system.build.toplevel`: build one host explicitly; CI repeats this for `evilbook`, `evilcloud`, and `rynepc`.

## Coding Style & Naming Conventions

Use two-space indentation in Nix files and format them with `nixfmt`. Run `statix check .` for Nix linting. Keep modules small and scoped by host, user, or aspect. Follow existing lowercase, hyphenated names for Nix files and aspect directories (for example, `vm-guest.nix` and `role/desktop/`). Python packages use `snake_case`; shell scripts use Bash and the `.bash` suffix. Do not hand-edit generated `flake.nix` or unrelated entries in `flake.lock`.

## Testing Guidelines

There is no separate unit-test suite or coverage target. `just check` is the minimum validation. For host-specific changes, build the affected `nixosConfigurations` output; use `just test` before `just switch` when changing activation-sensitive settings. Never run destructive disk-format or remote-install recipes merely for validation.

## Commit & Pull Request Guidelines

History favors short, imperative, lowercase subjects such as `fix option name` or `add wifi config`; lock-only updates use `flake.lock: Update`. Keep commits focused. Pull requests should identify affected hosts/users, summarize behavior changes, list validation commands, and call out secret, networking, partition, or boot implications. Include screenshots only for visible desktop or dotfile changes.

## Security & Secrets

Secrets come from the private `evilsecrets` flake input. Never commit decrypted secrets, credentials, generated system closures, or machine-local artifacts. Review changes to SSH, Wi-Fi, partitioning, and remote deployment settings especially carefully.

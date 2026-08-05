# AGENTS.md

Personal NixOS flake config (dendritic pattern: `den` + `flake-parts` + `import-tree`). Hosts: `evilbook` (desktop/niri, unstable), `evilcloud` (server + CI runner, 26.05), `rynepc` (desktop).

## Critical gotchas

- **`flake.nix` is generated — never edit it.** Add/change inputs via `flake-file.inputs` in `modules/dendritic.nix` (or the module using them), then regenerate with `nix run .#write-flake`.
- **Evaluation requires the private `evilsecrets` input** (`git+ssh://github.com/sttagent/evilwoods-nixos-config-secrets`, `flake = false`). No SSH access to that repo = nothing builds or evaluates. Secrets live in that repo under `secrets/hosts/common.yaml`, `secrets/users/<user>.yaml`, `secrets/services/*.yaml` (sops-nix).
- **Files/dirs prefixed with `_` are not imported** by import-tree (e.g. `modules/_vm.nix`, `modules/hosts/rynepc/_rynepc.nix` are disabled on purpose). Rename to enable.
- Repo is used with **jujutsu (`.jj`) colocated with git** — ask before any git mutation.

## Architecture (dendritic)

- Every `*.nix` file under `modules/` is auto-imported as a flake-parts module; no manual import lists at the flake level.
- Reusable config = **aspects**: `modules/aspects/<group>/<name>.nix` defines `den.aspects.<group>.<name>` with `nixos` and/or `homeManager` attrsets. Hosts compose them via `includes`.
- Hosts: declared in `modules/hosts/<host>/host.nix` as `den.hosts.x86_64-linux.<host>` with `channel` (`nixos-unstable` | `nixos-2605`, see `modules/schema/host.nix`), `stateVersion`, `mainUser`, plus a matching `den.aspects.<host>` that `includes` role/hardware/service aspects.
- Users: base home config in `modules/users/<user>/user.nix` (`den.aspects.<user>`); per-host user config as nested `den.aspects.<user>.<host>` (e.g. `modules/users/aitvaras/at-evilbook.nix`).
- Dual-channel: each host pins unstable or 26.05 (`*-2605` inputs follow `nixpkgs-2605`). Keep `inputs.X.follows` consistent with the channel of the hosts using that input.
- `den.reservedKeys = [ "settings" ]` (modules/defaults.nix) — don't use `settings` as an aspect key.

## Commands

- `just check` → `nix flake check`; `just update` → `nix flake update --commit-lock-file`.
- `just build|test|switch|boot` → `nix run .#$(hostname) [-- test|switch|boot]` (per-host `nh` apps generated in `modules/nh.nix`).
- Build one host without activating: `nix build .#nixosConfigurations.<host>.config.system.build.toplevel`.
- `nix run .#write-flake` — regenerate `flake.nix` after touching `flake-file.inputs`.
- Dev shell via direnv (`.envrc` → `use flake`); formatter is `nixfmt`, linter `statix` (both in the dev shell).

## CI / deploy

- `.github/workflows/build-hosts.yml` runs on a **self-hosted runner on evilcloud** (`modules/hosts/evilcloud/services/nixos-runner.nix`): builds all 3 hosts on pushes to `main` touching `modules/**`, then pushes the flake privately to FlakeHub.
- Fresh installs: `just install-nixos-local <config>` / `just install-nixos-remote <config> <host> <extra-files>` (nixos-anywhere + disko; partition layouts in `modules/hosts/<host>/partitions.nix`).

## Conventions

- `TODO.md` lists known deduplication/refactor plans — check it before introducing new boilerplate patterns; prefer extending it over silently duplicating.
- Dotfiles for user programs live in `dotfiles/` and are linked via `xdg.configFile` from user aspects, not via home-manager `programs.*` options, when the tool lacks good HM support.

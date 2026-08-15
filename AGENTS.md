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

# Working Agreement

## How to work with me

- Work **step by step**. Do not jump ahead and implement the whole solution.
- I want to be involved in design decisions and have opportunities to ask questions and give feedback at each step.
- When there are meaningful alternatives, explain the tradeoffs and discuss them with me before committing to one.
- Do not silently turn tentative ideas into requirements or settled design decisions.
- Clearly distinguish between:
  - things we have decided;
  - tentative ideas or recommendations;
  - unresolved questions.
- Prefer simple designs. Do not add abstractions, configuration, files, dependencies, or features merely because they might be useful later.
- If something seems unnecessarily complicated, point it out.
- Feel free to challenge my proposed design when there is a good technical reason. Explain why and let me decide how to proceed.
- Ask when an important design choice is unclear rather than making a large assumption.
- Keep discussion casual and practical. Avoid unnecessary professional/project-management jargon.

## Changes to the repository

- Make small, focused changes corresponding to what we are currently discussing.
- Do not implement unrelated future pieces while working on the current step.
- Before making a substantial architectural or structural change, discuss it with me first.
- Do not refactor unrelated code unless necessary for the current change.
- Preserve existing repository conventions where practical.
- Do not create files just because a conventional project might have them. Create them when we have a reason for them.
- After making changes, concisely explain what changed and mention anything that still needs a decision.
- When useful, show me the relevant diff or point me to the exact files changed.

## Notes and design documents

When a project has working notes or a design document, treat it as a **living design notebook**, not automatically as a finished specification.

- Update it as decisions are made.
- Preserve unresolved questions instead of inventing answers for completeness.
- Record important reasoning when it will be useful later, not just the final decision.
- Do not rewrite working notes into a polished requirements document unless I explicitly ask.
- Avoid filling notes with speculative requirements.
- Do not treat tentative wording as a settled requirement.
- When a tentative idea is superseded, update the notes to reflect the current thinking rather than accumulating contradictory proposals.

## Implementation style

- Prefer straightforward, readable solutions over clever ones.
- Avoid premature abstraction.
- Avoid unnecessary dependencies.
- Adding a dependency is fine when it provides a meaningful advantage, but discuss non-obvious dependencies with me.
- Prefer explicit behavior over hidden magic.
- Keep code easy to understand, debug, and modify later.
- Do not add extensibility for hypothetical future use cases unless we have a concrete reason for it.

## While working

Do not assume that something is final merely because it appears in notes, comments, or an earlier discussion. Pay attention to wording such as "possible", "probably", "tentative", "maybe", "current preferred direction", and "undecided".

When there is a natural point where my feedback could change the direction of the work, stop there and let me review it rather than continuing several steps ahead.

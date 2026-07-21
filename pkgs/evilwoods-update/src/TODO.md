# evilwoods-update implementation plan

This checklist turns `NOTES.md` into an implementation sequence. The notes are
the source of truth for detailed behavior; this file tracks work and the order
in which to do it.

The sequence intentionally leaves a runnable, manually inspectable program at
the end of each task. Until the deployment coordinator is complete, manual
checks must not touch the real system profile, bootloader, persistent state, or
ntfy service. Use temporary paths and mocked subprocess/HTTP boundaries for
those checks.

## Current state

- [x] The project notes describe the version 1 behavior and invariants.
- [x] A minimal Python package and `python -m evilwoods_update` entry point
  exist.
- [ ] The current placeholder implementation, package version, entry point,
  dependencies, tests, Nix derivation, and NixOS integration still need work.

## Decisions already made

- Python modules are limited initially to `cli.py`, `commands.py`, `state.py`,
  `deploy.py`, `flakehub.py`, and `notifications.py`, plus thin package entry
  files.
- Persistent state schema version is `1`; package version is `0.1.0`.
- All mutating commands are root-only and share one blocking `flock` lock.
- Automatic and manual operations only stage a system for the next boot; they
  never switch the running session or reboot it.
- State writes use durable atomic replacement. An intent is persisted before
  profile or bootloader mutation, and unfinished operations are recovered
  before new work.
- FlakeHub `commit_count` is the automatic-release high-water mark.
- Notifications are best-effort and never change an operation's result.
- Tests use `pytest` and mock host-mutating and network boundaries.
- The Den aspect itself enables the feature; there is no separate enable
  option.

## Still unresolved

- [ ] Decide which hosts include `den.aspects.services.evilwoods-update` after
  the aspect is implemented and reviewed. Do not add host imports as part of
  the initial implementation.
- [ ] Before the first real deployment smoke test, choose a disposable or
  otherwise safe NixOS host and agree on recovery access. This is an operational
  choice, not a new program feature.

## 1. Establish the package and CLI shell

- [x] Update `pyproject.toml`:
  - [x] Set package version to `0.1.0`.
  - [x] Add `requests` as the runtime dependency.
  - [x] Point the console script at `evilwoods_update.cli:main`.
- [x] Make `__main__.py` a thin wrapper around `cli.main()` and remove the
  placeholder `main` from `__init__.py`.
- [x] Add `cli.py` with `main(argv)` and parsers for `update`,
  `stage <store-path>`, `hold`, `resume`, and `status`.
- [x] Implement usage exit code `2`, outer `KeyboardInterrupt` handling with
  exit code `130`, stderr logging, and immediate root checks for mutating
  commands.
- [x] Add `test_cli.py` for parsing, dispatch, privilege rejection, exit-code
  mapping, and interruption handling.
- [x] Manual checkpoint:
  - [x] Run `python -m evilwoods_update --help`.
  - [x] Run every subcommand with `--help` and try invalid/missing arguments.
  - [x] As a non-root user, confirm mutating commands fail before any command
    implementation is invoked and `status` is allowed to dispatch.

## 2. Model and strictly validate state

- [ ] Add frozen dataclasses in `state.py`: `State`, `AutomaticRelease`,
  `StagedDeployment`, `StagingIntent`, and `RecoveryFailure`.
- [ ] Define fixed `pathlib.Path` constants for the state directory, state
  file, current-system link, and any other host paths owned by this module.
- [ ] Implement exact schema-version-1 parsing:
  - [ ] Require exactly the documented fields at every object level.
  - [ ] Validate scalar types and values, including rejecting Boolean commit
    counts.
  - [ ] Validate syntactic absolute `/nix/store/...` paths without requiring
    them to exist.
  - [ ] Enforce all mode, staged-deployment, intent, recovery-failure, and
    monotonic-ID cross-field invariants from `NOTES.md`.
  - [ ] Reject missing/unknown schema versions and invalid state without
    silently initializing over it.
- [ ] Implement deterministic serialization with documented field order,
  two-space indentation, explicit nulls, and a trailing newline.
- [ ] Add `test_state.py` covering valid objects, every validation category,
  exact round trips, and representative contradictory field combinations.
- [ ] Manual checkpoint:
  - [ ] Parse and pretty-print representative held, automatic, staged, intent,
    and failed-recovery JSON files from a temporary directory.
  - [ ] Deliberately add an unknown field and corrupt a type; confirm each
    produces a clear error and preserves the input file.

## 3. Make state persistence durable and reconciliation pure

- [ ] Implement loading absent, valid, and invalid state without side effects.
- [ ] Implement initialization of absent state as held, using the validated
  `/run/current-system` target as its baseline.
- [ ] Implement durable atomic saving:
  - [ ] Open the fixed `.tmp` path without following symlinks or initially
    truncating an existing file.
  - [ ] Set temporary mode `0600`, truncate, serialize, then explicitly set
    `root:root` and final mode `0644`.
  - [ ] Flush and `fsync` the file, `os.replace` it, then `fsync` the state
    directory.
  - [ ] Distinguish failure before replacement from directory-sync failure
    after replacement.
- [ ] Add an explicit state-directory sync operation for mutating-command
  startup.
- [ ] Implement pure reconciliation for unchanged running state,
  staged-to-running promotion, and unexpected external activation/rollback.
- [ ] Extend `test_state.py` for initialization, write ordering, permissions,
  replacement failure, post-replacement sync failure, and every reconciliation
  result/event.
- [ ] Manual checkpoint:
  - [ ] Monkeypatch state/current-system paths to a temporary tree and run a
    small state-module harness through initialization and all three
    reconciliation cases.
  - [ ] Inspect JSON formatting and permissions after each write.
  - [ ] Inject failures before and after replacement and confirm the reported
    authority/durability distinction.

## 4. Implement notification configuration and delivery in isolation

- [ ] Add `notifications.py` with fixed configuration path, title construction,
  priority/header handling, `(5, 10)` timeout, revision shortening, and
  one-line 500-character error normalization.
- [ ] Strictly validate config JSON containing only `ntfy_topic_url`, including
  the documented URL restrictions.
- [ ] Post plain-text events through `requests`, follow normal redirects, call
  `raise_for_status()`, and bound response-body logging.
- [ ] Make missing/invalid config and all transport failures non-raising and
  clearly logged.
- [ ] Keep event-specific wording in `commands.py`; expose only small formatting
  and transport helpers here.
- [ ] Add `test_notifications.py` for config validation, exact headers/body,
  hostname title, priorities, timeout, truncation, redirects/non-2xx behavior,
  and failure isolation.
- [ ] Manual checkpoint:
  - [ ] Point the module at temporary valid and invalid configs and inspect the
    prepared request using a local/mock HTTP endpoint.
  - [ ] Confirm no request is attempted for bad config and simulated delivery
    failures do not escape.

## 5. Build candidate validation and temporary-root lifecycle

- [ ] Add `deploy.py` path constants and small structured result/error types
  needed by callers; avoid class hierarchies or a general subprocess framework.
- [ ] Implement canonical candidate path validation:
  - [ ] Resolve once to a direct child of `/nix/store`.
  - [ ] Require the `nixos-system-<hostname>-` store-name prefix.
  - [ ] Run `nix path-info --recursive <candidate>`.
  - [ ] Require executable `bin/switch-to-configuration`.
- [ ] Implement cautious `/run/evilwoods-update/candidate` handling:
  - [ ] Remove stale symlinks only; reject other file types.
  - [ ] Create the registered manual root with `nix-store --realise ...
    --add-root ... --option substitute false`.
  - [ ] Resolve an automatic fetch result only when the candidate is a valid
    symlink to a store path.
  - [ ] Remove the root after use, but return/log a non-fatal warning when
    cleanup fails after successful staging.
  - [ ] Retain it when failed recovery requires inspection and report whether
    it was actually retained.
- [ ] Add initial `test_deploy.py` cases for path shape, wrong host, incomplete
  closure, missing/non-executable activation program, exact Nix arguments,
  symlink resolution, stale cleanup, unexpected runtime objects, and cleanup
  warnings.
- [ ] Manual checkpoint:
  - [ ] Exercise validators against harmless fake paths and mocked command
    results in a temporary directory.
  - [ ] If a local realized NixOS system path is available, run only the
    read-only validator (`nix path-info` plus file checks); do not set the
    system profile yet.

## 6. Implement staging transactions and recovery

- [ ] Implement reading and validating the current system-profile target only
  when staging or recovery needs it.
- [ ] Implement the shared next-boot staging sequence with argument lists and
  `shell=False`:
  - [ ] Persist an operation-specific staging intent before mutation.
  - [ ] Run `nix-env --profile /nix/var/nix/profiles/system --set <candidate>`.
  - [ ] Run candidate `switch-to-configuration boot`.
  - [ ] Persist final staged state only after both succeed.
- [ ] Implement failure classification and compensation:
  - [ ] After a failed profile set, re-read the profile and skip compensation
    only when it definitely stayed unchanged.
  - [ ] Otherwise restore the previous profile, then run its boot activation.
  - [ ] Preserve held/automatic mode according to `update`, `stage`, or
    `resume` semantics.
  - [ ] Handle failure of final state replacement, including the distinct
    post-replacement directory-sync case.
- [ ] Implement startup recovery of unfinished intents as the only mutation in
  that invocation; clear a successfully recovered intent and exit `1`.
- [ ] Latch failed recovery in held mode with normalized original/recovery
  errors, retaining the intent and blocking later mutating work.
- [ ] Extend `test_deploy.py` for exact subprocess order and every failure point:
  intent write, profile set unchanged/changed/unreadable, candidate boot step,
  profile restoration, previous boot step, final state write, interrupted
  `update`/`stage`/`resume`, and failed-recovery latching.
- [ ] Manual checkpoint:
  - [ ] Run scenario-driven tests with fake executables that record arguments
    and fail at selectable steps.
  - [ ] Inspect state after each injected failure and confirm no later command
    runs once a recovery failure is latched.
  - [ ] Defer all real profile and bootloader mutation to the gated host smoke
    test in task 11.

## 7. Implement FlakeHub authentication, discovery, and fetch

- [ ] Add `flakehub.py` with the fixed repository identifier and hostname-based
  output selection.
- [ ] Run and classify `fh status` authentication checks.
- [ ] Run `fh list releases ... --limit 1 --json` and strictly validate the
  response, including empty lists, scalar types, and required release fields.
- [ ] Construct the exact reference from `simplified_version`; retain full
  version/revision and numeric commit count in returned metadata.
- [ ] Implement fetch to the runtime candidate link with one 30-second delayed
  retry after any nonzero exit:
  - [ ] Clean a partial symlink before retry and after final failure.
  - [ ] Do not retry malformed successful output/candidate shape.
  - [ ] Resolve once and return the canonical candidate path for shared
    validation/staging.
- [ ] Add `test_flakehub.py` for exact commands/references, authentication
  failure, malformed/empty discovery results, equal/lower/new IDs as applicable
  to returned data, retry timing, both fetch attempts, cleanup, and invalid
  result symlinks.
- [ ] Manual checkpoint:
  - [ ] Run against a fake `fh` executable to inspect exact arguments and retry
    behavior without network access.
  - [ ] On an authenticated development host, optionally run only `fh status`
    and release discovery; do not fetch or stage as part of this checkpoint.

## 8. Add command workflow scaffolding, locking, and status

- [ ] Add `commands.py` and its private lock context manager:
  - [ ] Open the fixed runtime lock.
  - [ ] Try non-blocking `flock`, print the waiting message only on contention,
    then block interruptibly and always release.
- [ ] Create the common mutating-command startup flow while keeping decisions
  explicit: lock, state-directory sync, state load/initialization, unfinished
  intent handling, current-system validation, reconciliation/persistence, and
  latched-failure guard.
- [ ] Send the required initialization, reconciliation, recovery, invalid-state,
  and state-write notifications only after the corresponding durability point.
- [ ] Implement strictly read-only `status`:
  - [ ] Handle absent state without creating it or notifying.
  - [ ] Always print `Mode`, `Running`, `Staged`, and `Latest automatic release`
    for valid initialized state.
  - [ ] Show staged origin/release, intents, recovery failures, and pending
    reconciliation when applicable.
  - [ ] Exit `1` for invalid/unreadable state, invalid current-system, or a
    latched recovery failure; pending reconciliation alone exits `0`.
  - [ ] Never acquire the lock.
- [ ] Add `test_commands.py` for contention, startup ordering/abort points,
  initialization, reconciliation events, held reminder suppression, recovery
  blocking, and status output/exit behavior.
- [ ] Wire the implemented commands through `cli.py`.
- [ ] Manual checkpoint:
  - [ ] Run `status` against temporary absent, valid, invalid, staged, pending
    reconciliation, and failed-recovery fixtures as a non-root user.
  - [ ] Hold the temporary lock from another process and confirm a mutating
    command prints once, waits, then continues after release.

## 9. Implement `hold` and manual `stage`

- [ ] Implement idempotent `hold`, preserving staged state and release metadata;
  persist and notify only on a real transition.
- [ ] Implement manual `stage` in this order: startup/reconciliation, full
  validation and temporary rooting, durable held transition, then shared
  staging.
- [ ] Preserve the automatic-release high-water mark and remain held after an
  accepted manual request even when staging later fails.
- [ ] Handle manual no-op/adoption cases without unnecessary profile or
  bootloader calls:
  - [ ] Active path with no different pending path.
  - [ ] Active path cancelling a different pending path.
  - [ ] Path already staged manually.
  - [ ] Adoption/reclassification of an automatically staged path.
- [ ] Emit the exact held, manual staging, adoption, cancellation, staging
  failure, recovery, and cleanup-warning messages and priorities from the notes.
- [ ] Extend command/deploy tests across the full manual-stage decision table,
  including validation failure leaving mode unchanged.
- [ ] Manual checkpoint:
  - [ ] Run `hold` and every manual-stage branch through temporary state and
    mocked Nix commands; inspect command traces, state JSON, output, and captured
    notification requests after each run.
  - [ ] Confirm rerunning no-op cases causes no unnecessary state write,
    activation, or duplicate notification.

## 10. Implement automatic `update` and transactional `resume`

- [ ] Implement held `update` as a successful early exit with the routine
  reminder, except when the invocation already sent a held-transition event.
- [ ] Implement normal automatic release ordering:
  - [ ] Equal ID is a no-op without fetch, write, or notification.
  - [ ] Lower ID is rejected and warned without state mutation.
  - [ ] Strictly newer ID proceeds through fetch, validation, and staging.
- [ ] Implement newer-release path cases:
  - [ ] Candidate exactly matches already-staged automatic release (idempotent).
  - [ ] New metadata points at the same staged system.
  - [ ] Candidate is already running with nothing else staged.
  - [ ] Candidate is running while an older automatic system is staged.
  - [ ] Candidate differs and replaces or creates the pending automatic system.
- [ ] Implement transactional `resume`:
  - [ ] Already-automatic mode runs a normal immediate check without rewriting
    or repeating the resumed notification.
  - [ ] Held mode remains held throughout authentication, discovery, fetch,
    validation, and any `resume` staging intent.
  - [ ] Equal accepted ID may be fetched; lower ID fails held.
  - [ ] Commit automatic mode only after the latest release is staged or
    confirmed/reclassified as the authoritative running or next-boot choice.
  - [ ] Handle running, manually pending, reclassified, cancelled-manual, and
    newly staged cases with the documented notification combinations.
- [ ] Keep discovery/fetch/authentication failures retryable in automatic mode
  and held during transactional resume.
- [ ] Add the remaining exact notification templates and priorities in
  `commands.py`.
- [ ] Extend `test_commands.py` into complete `update` and `resume` decision
  tables, asserting state, external calls, notification order, exit status, and
  idempotency for each branch.
- [ ] Manual checkpoint:
  - [ ] Run end-to-end workflows using fake `fh`, Nix, activation, and ntfy
    endpoints, with temporary state/runtime paths.
  - [ ] Simulate several timer runs and reboots by changing the fake
    current-system target; confirm monotonic IDs, promotion, held protection,
    retry behavior, and notification suppression/ordering.

## 11. Finish Nix packaging and Den integration

- [ ] Update `pkgs/evilwoods-update/package.nix`:
  - [ ] Add `requests` to deployed Python dependencies.
  - [ ] Add `pytestCheckHook` and `pytest` as native check dependencies.
  - [ ] Ensure the test suite runs during the package build.
  - [ ] Fix the development-shell path to the canonical
    `pkgs/evilwoods-update/src` directory.
  - [ ] Include `requests` and `pytest` in the development shell.
- [ ] Add `modules/aspects/services/evilwoods-update.nix` as
  `den.aspects.services.evilwoods-update`:
  - [ ] Install `self.packages.${pkgs.system}.evilwoods-update` and `pkgs.fh`.
  - [ ] Generate strict `/etc/evilwoods-update/config.json` with the complete
    ntfy topic URL.
  - [ ] Add tmpfiles rules for `/var/lib/evilwoods-update` (`0755`),
    `/run/evilwoods-update` (`0700`), and `update.lock` (`0600`) with root
    ownership; let the program create `state.json` as `0644`.
  - [ ] Add root oneshot `evilwoods-update.service` invoking `update`, with
    `HOME=/root`, the required executable path, network-online ordering/wants,
    and `TimeoutStartSec=infinity`.
  - [ ] Add `evilwoods-update.timer` with `OnBootSec=5m`,
    `OnUnitActiveSec=6h`, and `RandomizedDelaySec=15m`.
  - [ ] Do not add a tailscaled hard dependency, reboot behavior, enable
    option, or host inclusion.
- [ ] Verification checkpoint:
  - [ ] Run the full pytest suite in the development shell.
  - [ ] Build the Nix package and confirm its check phase runs pytest.
  - [ ] Evaluate/build the aspect configuration without adding it to a host.
  - [ ] Inspect generated service, timer, tmpfiles, config, closure contents,
    executable PATH, and installed console entry point.

## 12. Gated real-host smoke test and operator handoff

Do this only after tasks 1–11 pass and a suitable host/recovery plan has been
chosen. These checks intentionally mutate NixOS profile and bootloader state.

- [ ] Install/include the reviewed aspect on the selected host.
- [ ] Confirm tmpfiles ownership/modes, world-readable but root-owned state,
  root-only runtime contents, generated config, and unit definitions.
- [ ] Confirm non-root `status` works and all mutating commands reject non-root
  callers.
- [ ] Run the first root command and verify held initialization, durable state,
  and its notification.
- [ ] Authenticate root with `sudo fh login`; verify the service's `HOME=/root`
  sees the credentials via `fh status`.
- [ ] Exercise `hold` idempotency and a safe `resume`/automatic check.
- [ ] Stage a known-good already-present system manually and confirm:
  - [ ] Running session stays unchanged.
  - [ ] Standard profile and boot entry select the candidate for next boot.
  - [ ] State records held/manual staged metadata.
- [ ] Reboot, run `status`, then run a root mutating command to verify promotion
  and activation notification.
- [ ] Where safe, test interrupted-intent recovery using a controlled failure;
  do not deliberately induce failed compensation on a machine without console
  recovery.
- [ ] Start the systemd service and timer, then inspect journal output,
  notification delivery, scheduling, and absence of unintended reboot/switch.
- [ ] Decide which production hosts should include the aspect.

## Completion checks

- [ ] Every documented command and state transition has a focused automated
  test, including failure paths and idempotent no-ops.
- [ ] No test touches the real state file, system profile, bootloader, runtime
  candidate root, FlakeHub account, or ntfy instance.
- [ ] All subprocess calls use argument lists with `shell=False`; unbounded
  command output stays in local logs and notification errors are sanitized.
- [ ] Mutating workflows hold the shared lock and never proceed past uncertain
  or invalid durable state.
- [ ] Notification failures never alter state/deployment results.
- [ ] No version-2 ideas, rollback/force command, JSON status, hostname/config
  generalization, persistent emergency root, remote copy orchestration, or host
  enablement has slipped into version 1.

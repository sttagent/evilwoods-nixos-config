# NixOS cache deployer — project notes

These working project notes are not a finished requirements document.

## Established requirements

The script must automatically pull and stage a host's prebuilt NixOS closure
from FlakeHub Cache, or stage an already-copied closure.

From the user's perspective, automatic updates must behave like
atomic-distribution updates: silently fetch and stage the new system without
switching the running session, then activate it on the next boot.

It must never overwrite a manual deployment with an older cached build:

- manual deployments and unexpected external activations or rollbacks switch
  the updater from automatic mode to held mode until explicitly resumed;
- newly accepted automatic releases must have strictly higher deployment IDs;
  `resume` may reuse the current high-water mark to restore the already-accepted
  automatic system after a manual deployment.

Persistent state must live in:

`/var/lib/evilwoods-update/state.json`

Automatic and manual operations must share this `flock` lock:

`/run/evilwoods-update/update.lock`

to prevent concurrent deployments.

The deployer must make a best-effort attempt to report deployment outcomes and
updater state changes remotely through the self-hosted ntfy instance.

Mutating updater state, the system profile, or bootloader state requires root,
and the systemd update service runs as root. Because `status` may run as a
non-root user, `state.json` must contain no secrets and be world-readable but
writable only by root. Use mode `0755` for the root-owned state directory and
`0644` for the root-owned state file.

## Repository / source-side inventory

The files live in the existing NixOS configuration repository.

### Python project

The canonical package directory is `pkgs/evilwoods-update/`, not
`packages/evilwoods-update/`.

- `pyproject.toml`
  - The deployer is a Python project packaged as a Nix derivation.
  - Use package version `0.1.0` for the initial working implementation, updating
    the current `0.0.0` placeholder. Package versioning is independent of
    persistent state `schema_version`, initially `1`.
  - Declare `requests` as a runtime dependency in project metadata and
    `package.nix`'s Python dependencies so the Nix closure contains it.
  - The NixOS aspect consumes the existing flake package output as
    `self.packages.${pkgs.system}.evilwoods-update`; it does not add an overlay
    or call the derivation separately.

- Python package source files
  - Use a few focused modules instead of putting everything in `__main__.py`, so
    CLI parsing, state persistence, recovery, FlakeHub operations, and
    notification delivery can be tested independently. Keep the split small and
    responsibility-based; add no classes or framework-style abstractions
    without a concrete need.
  - Keep `__main__.py` as a thin entry point that imports `main` from `cli.py`
    and exits with its return value. Put argument parsing and command dispatch
    in a testable `cli.py` function, `main(argv)`.
  - Declare the installed console script in `pyproject.toml` as
    `evilwoods-update = "evilwoods_update.cli:main"`. Keep
    `python -m evilwoods_update` working through the thin `__main__.py`; no
    separate wrapper script is needed.
  - `commands.py` implements `update`, `stage`, `hold`, `resume`, and `status`,
    coordinating locking, reconciliation, deployment, FlakeHub operations, and
    notifications. `cli.py` handles parsing, early privilege checks, user-facing
    output, and mapping results or exceptions to exit codes.
  - `deploy.py` owns local candidate validation, the shared runtime candidate-root
    lifecycle, and NixOS staging: cautious stale-path cleanup, registered manual
    root creation and cleanup, reading the current system-profile target,
    persisting staging intent through `state.py`, running `nix-env --set` and
    `switch-to-configuration boot`, and performing compensating or
    interrupted-intent recovery. It accepts the operation kind and returns
    structured results/events, but neither discovers FlakeHub releases nor
    delivers notifications.
  - `flakehub.py` owns all `fh` interaction and automatic fetch-result handling:
    authentication, release discovery and response validation, exact-reference
    construction, fetching with one delayed retry, and candidate-symlink
    resolution. It returns release metadata and a resolved candidate path;
    `deploy.py` performs shared host and NixOS-system validation and candidate-root
    cleanup.
  - `notifications.py` owns static configuration loading and ntfy transport:
    the stable title, request headers, priorities, timeout, revision shortening,
    error truncation, and non-raising logging of delivery or configuration
    failures. `commands.py` supplies event-specific text because it knows what
    occurred.
  - Keep lock acquisition in a small private `commands.py` context manager that
    opens the runtime lock, emits the delayed waiting message, blocks in `flock`,
    and reliably releases it. Every acquisition occurs at a workflow boundary,
    so a separate `lock.py` is unnecessary.
  - Initial modules are `__init__.py`, `__main__.py`, `cli.py`, `commands.py`,
    `state.py`, `deploy.py`, `flakehub.py`, and `notifications.py`.
  - Represent validated state with frozen standard-library dataclasses:
    `State`, `AutomaticRelease`, `StagedDeployment`, `StagingIntent`, and
    `RecoveryFailure`.
    State transitions construct new values instead of mutating values that could
    be mistaken for durable state. No modeling dependency is needed.
  - `state.py` owns those dataclasses, strict JSON parsing and validation,
    durable atomic load/save functions, and pure reconciliation. Reconciliation
    takes state and the observed current-system path, then returns the resulting
    state and an event description. The caller persists and reports the result;
    reconciliation invokes no deployment subprocesses or notifications.
  - The package contains target-host deployment logic only; it does not
    orchestrate copying closures or invoking remote hosts.

- Tests
  - Use `pytest` only for tests. Its fixtures, parametrization, and monkeypatching
    materially simplify the many schema and subprocess failure cases; exclude
    it from deployed runtime dependencies.
  - Tests live in `pkgs/evilwoods-update/src/tests/`, beside `pyproject.toml` and
    the `evilwoods_update/` package.
  - Start with `test_cli.py`, `test_commands.py`, `test_deploy.py`,
    `test_flakehub.py`, `test_notifications.py`, and `test_state.py`, mirroring
    the responsibility-based implementation modules. Do not create
    `conftest.py` until at least two test files genuinely share a fixture.
  - Run the suite from the Nix package build using `pytestCheckHook`. Keep
    pytest as a native check dependency so it does not propagate into the
    deployed closure.
  - The package development shell includes runtime dependency `requests` and
    test dependency `pytest`, letting the CLI and tests run without additional
    setup or changing the deployed closure.
  - Initial tests are non-privileged and must never mutate the real Nix system
    profile or bootloader. Use temporary directories and mocked subprocess/HTTP
    boundaries to test schema and durability, command sequencing and recovery,
    exact external-command arguments, notification formatting, and failure
    isolation. Package builds and later host `just test` runs provide broader
    integration validation.
  - Represent fixed host paths as simple module-level `pathlib.Path` constants
    and monkeypatch them to temporary directories in tests. Do not add CLI
    flags, environment overrides, or a production configuration object solely
    for test redirection.

### Nix / Den integration

- A Den aspect will contain the NixOS/systemd integration.
- Systemd service/timer files need not exist separately when declared directly
  in the aspect's NixOS configuration.
- The aspect will contain:
  - installation of the Python package and `pkgs.fh` in
    `environment.systemPackages`;
  - the automatic update service;
  - the timer for automatic updates;
  - systemd-tmpfiles rules for the persistent state directory and the runtime
    directory used for the lock and temporary FlakeHub fetch root;
  - static configuration needed by the deployer.

Neither the aspect nor deployer directly creates the state and runtime
directories or sets their permissions. The aspect declares systemd-tmpfiles
rules, and systemd creates them with the required ownership and permissions at
boot. Both are then available to operator-invoked commands and the automatic
update service. The state directory under `/var/lib` persists across reboots;
systemd recreates the runtime directory under `/run` each boot.

The aspect owns its `fh` dependency instead of relying on the separate
Determinate aspect. Ensure the automatic service's executable path also contains
the required Nix and FlakeHub commands. Installing `fh` system-wide also lets
the operator perform the required root `fh login`.

Put the NixOS/systemd integration in
`modules/aspects/services/evilwoods-update.nix` as
`den.aspects.services.evilwoods-update`. Keep the service, timer, tmpfiles rules,
generated static configuration, and package installation together in that one
aspect file initially. The package derivation remains separate at
`pkgs/evilwoods-update/package.nix`; split the aspect only if it later becomes
genuinely difficult to navigate.

Which hosts include this aspect remains intentionally undecided for the operator
to choose later. Do not add an enable option; including or excluding the Den
aspect is the enable mechanism.

Use one timer schedule for all hosts rather than per-host configuration: check
after boot and every six hours thereafter. Wait five minutes after boot for
networking, DNS, Tailscale, and other dependencies to settle, then add a
15-minute randomized delay so hosts do not contact FlakeHub and ntfy together.
The first check therefore occurs roughly 5–20 minutes after boot; later
six-hour runs are similarly staggered. Implement this as a relative timer with
`OnBootSec=5m`, `OnUnitActiveSec=6h`, and `RandomizedDelaySec=15m`, not fixed
wall-clock times. The updater stages systems only for the next boot and never
initiates reboots; any nightly server reboot policy is separate.

Name the units `evilwoods-update.service` and `evilwoods-update.timer`. The
service invokes `evilwoods-update update` as a oneshot. Explicitly set
`TimeoutStartSec=infinity` so systemd's default start timeout does not terminate
a legitimate slow fetch or bootloader update.

Have the service want and start after `network-online.target`, without a hard
dependency on `tailscaled.service`. FlakeHub needs general network access, while
best-effort ntfy delivery over Tailscale must not gate updates; the five-minute
delay also lets Tailscale start normally. Run the service explicitly as root and
set `HOME=/root`, ensuring scheduled `fh` commands use credentials created by
interactive `sudo fh login` rather than service-manager environment defaults.

## Files/directories created or used on a deployed host

### Persistent state

`/var/lib/evilwoods-update/state.json`

Schema version `1` must represent:

- integer `schema_version`, initially `1`;
- updater mode: automatic or held;
- the running system baseline last recognized by the updater;
- any system staged by the updater for the next boot;
- the latest automatic release successfully accepted by the updater, including
  its numeric `commit_count`, full FlakeHub `version`, and Git `revision`;
- any staging operation currently in progress, including the candidate and the
  previous system-profile target needed for recovery.

Every state object must contain exactly the fields defined by its schema version.
Use explicit JSON `null` when an optional staged system, accepted automatic
release, or staging intent is absent. Missing or unknown fields are validation
errors; future fields require a new schema version rather than being silently
ignored by older code.

When loading state, require recorded system paths to be syntactically valid,
absolute `/nix/store/...` paths, but neither invoke Nix nor require their
continued existence. Runtime commands verify existence and executability when
using a path, such as during recovery. This keeps `status` lightweight and lets
it classify a missing recorded path as an environmental problem, not malformed
JSON structure.

Scalar schema rules require `mode` to be `automatic` or `held`, and intent
`operation` to be `update`, `stage`, or `resume`. `commit_count` is a
non-negative JSON integer; reject Booleans despite Python treating them as
integers. `version`, `revision`, `original_error`, and `recovery_error` are
non-empty strings. Persistent-state validation imposes no stricter FlakeHub
version syntax or Git revision length.

Enforce cross-field consistency as part of schema validation:

- a non-null `staged_deployment.system` must not equal `running_system`;
- automatic mode requires a non-null `latest_automatic_release`; fresh or
  deleted state initializes held, and transactional `resume` cannot enter
  automatic mode before accepting a release;
- an automatic staged deployment requires a non-null `automatic_release`, while
  a manual staged deployment requires it to be null;
- an automatic staged deployment's `automatic_release` must exactly equal
  `latest_automatic_release`, because successful automatic staging accepts that
  release at the same commit;
- a manual staged deployment requires held mode; transactional `resume` must
  replace or reclassify it as the authoritative automatic system before
  committing automatic mode;
- a `stage` intent requires held mode and a null `automatic_release`;
- a `resume` intent requires held mode and a non-null `automatic_release`;
- an `update` intent requires a non-null `automatic_release` and, while
  `staging_intent.recovery_failure` is null, automatic mode;
- a non-null `staging_intent.recovery_failure` requires held mode.

These combinations are contradictory rather than alternate states for runtime
code to interpret.

When `latest_automatic_release` exists, an `update` intent's `commit_count` must
be strictly greater. A `resume` intent may equal that count because returning
from a manual deployment can require re-fetching the last accepted release, but
must not be lower. Before any release is accepted, every non-negative candidate
count is valid.

Schema version `1` has exactly these top-level fields:

- `schema_version`;
- `mode`;
- `running_system`;
- `staged_deployment`;
- `latest_automatic_release`;
- `staging_intent`.

Recovery details belong inside non-null `staging_intent`, not a separate
top-level failure object.

A non-null `latest_automatic_release` has exactly three required fields: integer
`commit_count`, string `version`, and the full Git `revision`. FlakeHub's
`simplified_version` remains transient.

A non-null `staged_deployment` object has these required fields:

- `operation`, either `automatic` or `manual`;
- `system`, the staged system store path;
- `automatic_release`, using the release object above for an automatic
  deployment and `null` for a manual deployment.

This preserves enough origin information for reboot reconciliation to send the
correct automatic or manual notification. Use `null` when no system change is
pending for reboot.

A non-null `staging_intent` has these required fields:

- `operation`, either `update`, `stage`, or `resume`;
- `candidate_system`, the candidate system store path;
- `previous_profile`, the previous system-profile target needed for recovery;
- `automatic_release`, using the release object above for `update` or `resume`
  and `null` for `stage`;
- `recovery_failure`, initially `null`.

Keep `operation` explicit rather than inferring it from `automatic_release`, so
recovery behavior and diagnostics need no indirect clue. Successful recovery of
an interrupted `resume` returns to held mode; recovery of an interrupted normal
`update` returns to automatic mode.

On recovery failure, set `recovery_failure` to an object containing required
strings `original_error` and `recovery_error`. For an intent left by process
interruption, `original_error` states that an unfinished staging intent was
found; the surrounding intent retains the candidate and previous-profile paths.
Each error is a program-authored high-level summary that may identify the failed
step and exit status, but not captured stdout or stderr. Normalize each to one
line of at most 500 characters. This preserves durable context without putting
potentially sensitive subprocess output in world-readable state; full output
remains in system logs.

A non-null `recovery_failure` latches an operator-repair condition. Later
mutating commands keep held mode and intent unchanged, aborting before normal
work instead of retrying an already-failed recovery. Interactive commands report
stored errors locally; scheduled `update` runs repeat the priority-5
notification. Repeated automatic profile or bootloader recovery could worsen
the situation.

On recovery failure, retain `/run/evilwoods-update/candidate` and its registered
GC root if present instead of performing normal cleanup. The runtime root may be
absent after a reboot. If retained, it preserves the candidate closure for
inspection until deliberate repair, cleanup, or reboot. The urgent notification
says it was retained only when the runtime root was actually retained.

Do not add a persistent emergency GC root in version 1; it would require another
lifecycle and cleanup policy. The system-profile generation normally roots the
candidate, while the runtime root adds protection during immediate diagnosis.
Repair guidance tells the operator to create a separate persistent root before
reboot or garbage collection when preserving the candidate matters.

Version 1 has no `clear-recovery` or force command. The operator inspects the
journal, profile, boot entries, and retained intent; uses underlying NixOS tools
to repair and activate or stage a known-good system; preserves a diagnostic copy
of `state.json`; and deliberately removes the state file. The next root updater
command initializes fresh held state from `/run/current-system`. Automatic mode
resumes only after the operator reviews that baseline.

Potentially useful additional state should not be invented until there is a
concrete need.

Reject missing or unsupported schema versions clearly instead of guessing.
Migration machinery is unnecessary until a second version exists.

Do not replace malformed, incorrectly typed, or otherwise schema-invalid state
with fresh state. Mutating commands abort before touching the profile or
bootloader. `status` reports the error and exits with failure. Root mutating
commands make a best-effort priority-5 urgent failure notification; `status`
remains passive regardless of caller privileges. The operator must inspect and
repair or deliberately remove the invalid file, preserving possible recovery
evidence.

Write state using durable atomic replacement rather than modifying `state.json`
in place:

1. open `/var/lib/evilwoods-update/state.json.tmp` without following symlinks or
   truncating an existing file, set mode `0600`, then truncate it and serialize
   the complete state so non-root users cannot observe an incomplete write;
2. explicitly `fchown` the completed file to `root:root` and set final mode
   `0644`, without relying on stale-file metadata or process umask;
3. flush and `fsync` the temporary file;
4. replace `state.json` with `os.replace`;
5. `fsync` the state directory.

Serialize deterministic, human-readable JSON with two-space indentation,
documented schema field order, and a trailing newline. Readability helps
diagnosis and manual recovery, and the file is small.

This prevents partial reads and makes each state update resilient to interruption
or sudden power loss, but does not make the combined profile, bootloader, and
state operation atomic.

All writers hold the deployment lock, and other users cannot write the
root-owned state directory, so one fixed temporary path suffices. After a crash,
the next write safely truncates and reuses any leftover file instead of
accumulating unique temporary files. Readers open only `state.json`.

Distinguish failures before and after `os.replace`. Before replacement, old
state remains authoritative. If the subsequent directory `fsync` fails, new
state is visible but its durability across sudden power loss is uncertain;
report that distinction and abort. Never mutate the profile after an intent
write with uncertain durability; leave the visible intent for conservative
recovery. A mode-change command likewise must not continue into external
activation or an automatic check. Failure to replace final staging state
triggers compensating recovery as described under deployment. If replacement
succeeds but its directory `fsync` fails, report visible staged state as
durability-uncertain and abort without compensation.

After acquiring the lock, every root mutating command opens and `fsync`s the
state directory before recovery, reconciliation, or normal work. Success anchors
any visible rename left uncertain by an earlier process; failure aborts. This
avoids marker files at the cost of one directory sync per mutating invocation.

Before changing the system profile, atomically record a staging intent with the
candidate store path, previous profile target, and applicable automatic
deployment ID; the intent records that staging is in progress. After the profile
update and `switch-to-configuration boot` succeed, atomically replace it with
normal staged state.

If writing the intent fails, abort before changing the profile or bootloader,
return failure, and make a best-effort failure notification. A pre-replacement
failure leaves state and mode unchanged. A post-replacement directory-sync
failure may leave the intent visible without guaranteed durability; do not
proceed, and let the next mutating invocation recover conservatively.

A later invocation finding an unfinished intent recovers before normal state
reconciliation by restoring the previous profile target and running its
`switch-to-configuration boot`. Success clears the intent and reports the
interrupted deployment as failed. Failure enters held mode, retains enough
information for operator inspection, and sends a priority-5 urgent
notification. Recovery holds the normal deployment lock.

After recovering an interrupted intent, do not continue the triggering
operation. Persist the cleared intent, notify and report the deployment as
failed, and exit `1`. An interactive operator reruns deliberately; an automatic
update waits for the next timer. Recovery remains the abnormal invocation's only
mutation.

When `state.json` is absent, initialize schema version `1` in held mode, record
the active `/run/current-system` store path as baseline, and leave the latest
automatic release unset. Notify that initialization requires explicit `resume`.
This conservatively treats first installation and accidental deletion alike
because the updater cannot reliably distinguish them.

Read-only `status` is an exception: when `state.json` is absent and
`/run/current-system` resolves to a valid Nix store path, report the updater as
uninitialized, show the current system for context, and explain that a root
mutating command or automatic service run will initialize held state. Create no
state, send no notification, and exit successfully because uninitialized state
is valid status, not malformed state. An invalid current-system path instead
follows the operational-failure behavior below and exits `1`.

If a root command cannot write initial held state, abort without performing its
operation or changing the profile or bootloader. Report the error, attempt a
best-effort failure notification, and retry initialization on the next root
invocation. No mutation proceeds without durable state.

### Running/staged state reconciliation

Treat `/run/current-system` as an operational failure, not external activation
or an initialization baseline, when missing, unreadable, or not resolvable to a
Nix store path. Root mutating commands abort before changes and make a
best-effort priority-4 failure notification; `status` reports locally and exits
`1`.

Staging or recovery likewise aborts if `/nix/var/nix/profiles/system` is missing,
unreadable, or not resolvable to a store path. Inspect the profile only when an
operation needs it; mode-only `hold` and read-only `status` do not fail for a
profile they never inspect.

After startup directory sync and unfinished-intent handling, each mutating
command that has not aborted reconciles `/run/current-system` with state:

- if it matches the recorded running baseline, leave the baseline and staged
  path unchanged;
- if it matches `staged_deployment.system`, promote that path to the running
  baseline and clear `staged_deployment`, using the stored operation and release
  metadata when reporting the activation;
- if it matches neither, treat it as an external activation or rollback, update
  the running baseline to the observed path, enter held mode, clear
  `staged_deployment`, preserve `latest_automatic_release`, and notify.

A staged-to-running promotion preserves updater mode: automatic deployments
remain automatic after reboot, while manual deployments remain held. Normal
command startup performs reconciliation, so no boot-time commit service is
needed.

If reconciliation's atomic state replacement fails, abort before discovery,
fetching, or deployment. Old state remains authoritative before replacement;
after a post-replacement directory-sync failure, visible new state is
durability-uncertain. Send a best-effort failure notification describing the
detection and unsaved result, then retry next invocation. In particular, never
deploy automatically after detecting external activation unless held mode was
persisted successfully.

This check is intentionally conservative: missing or stale state may require
explicit operator review and resume rather than risk replacing a manual
deployment.

After external activation, clear staged metadata because the updater can no
longer claim its previous next-boot choice matches the profile and bootloader.
Held mode prevents automatic replacement during operator review.

`status` is strictly read-only: it reads state and `/run/current-system` without
persisting reconciliation or notifying. When it observes an unreconciled
staged-to-running promotion or external activation, report the observation and
pending reconciliation. The next root mutating command or automatic service run
reconciles before other work.

Version 1 provides only human-readable `status`; do not add `--json`. The state
file already provides readable JSON for advanced local inspection, while another
machine-readable interface would add an unneeded public schema.

For initialized valid state, always show predictable `Mode`, `Running`,
`Staged`, and `Latest automatic release` lines, using `none` for absent values.
When applicable, add the staged operation and release; staging-intent candidate
and previous paths; recovery-failure details; and a clear pending-reconciliation
warning.

Pending reconciliation exits successfully because `status` described valid
state and an observed condition. Unreadable, malformed, or schema-invalid state
exits `1`. Structurally valid state with latched `recovery_failure` also exits
`1`: print normal state, urgent stored errors, and repair guidance because the
condition blocks every mutating command and requires operator action.

`status` acquires no deployment lock. Atomic replacement ensures a complete old
or new state file, though the view may be transient during deployment. It
reports an advisory snapshot, including any staging intent; a later invocation
shows the settled result. Keeping the lock root-only also prevents unprivileged
users from blocking automatic deployments.

In automatic mode, a strictly newer FlakeHub deployment may replace an automatic
deployment staged for next boot. Update state with the replacement path and
release only after successful staging; equal or older IDs cannot replace it.
Thus, the next reboot uses the newest successfully published release then
available. Manual staging enters held mode and remains protected.

In automatic mode, when a candidate's store path and automatic release identity
match recorded staged state, treat the request as idempotent success: do not
update the profile or bootloader, rewrite unchanged state, or repeat the
notification. Report it as already staged. A manual request for an
already-manual staged path must still ensure held mode, like a manual request
for the active path.

If `stage` receives the exact path of a staged automatic deployment, treat the
operator as manually adopting it. Without rerunning profile or bootloader
commands, enter held mode, change `staged_deployment.operation` to `manual`, set
its `automatic_release` to null, and preserve `latest_automatic_release`. Notify
with priority 3, plus a held-transition notification when mode changes:

```text
Staged system adopted as a manual choice.
System: <store path>
```

The following strictly-newer-release cases apply to normal `update`;
transactional `resume` uses its command-specific rules below.

If a strictly newer automatic release resolves to the staged path, accept its
new ID, version, and revision without another profile or bootloader update.
Notify that the release was accepted but the system is unchanged. Use the newer
ID for future comparisons so the release is not rediscovered indefinitely.

If a strictly newer automatic release resolves to the running system with no
different system staged, accept its metadata, leave the baseline unchanged and
staged path empty, and do not update the profile or bootloader. Notify that the
release was accepted but already running. Never also record a running system as
staged; that would make reboot reconciliation ambiguous.

If a different automatic system is staged but a strictly newer release resolves
to the running system, use normal staging to restore the running system as the
next-boot choice, cancelling the older pending update. Accept the newer metadata
and clear the staged path instead of recording the running path as staged.
Notify that the pending update was replaced and no reboot change remains.

### Runtime lock and fetch root

`/run/evilwoods-update/update.lock`

Every operation that can change deployment state, the system profile, or the
bootloader must use this lock.

Interactive mutating commands wait indefinitely rather than time out during a
legitimately slow operation. First try non-blocking `flock`; if busy, immediately
print `Waiting for another update operation to finish...`, then block
interruptibly. This prints only during real contention without timers or
polling. In particular, `hold` returns only after the current lock owner finishes
and held mode is persisted.

Scheduled `update` also waits instead of skipping a busy run. Once locked, it
reconciles resulting state and checks for an update or observes held mode. All
mutating operations share this blocking policy.

The aspect's systemd-tmpfiles rule, not the deployer, creates the parent runtime
directory at boot. Through tmpfiles rules, create `/run/evilwoods-update` as
`root:root` mode `0700` and empty `update.lock` as `root:root` mode `0600`. Only
root mutating commands use runtime contents; non-root `status` reads persistent
state without accessing the lock or candidate symlink.

An automatic fetch temporarily uses this symlink:

`/run/evilwoods-update/candidate`

as a Nix GC root until the standard system profile roots the staged closure.

While locked, handle any existing candidate path after persisted-intent handling
and before creating a new automatic or manual candidate root. Remove a symlink
as stale residue; for any other file type, abort with an unexpected runtime-path
error instead of deleting blindly.

If post-staging candidate removal fails, keep the deployment successful because
the system profile roots the closure. Leave the symlink, log and send a
best-effort warning, and let the next `update`, `resume`, or `stage` retry stale
cleanup; otherwise reboot removes it. The only expected effect is an extra GC
root until cleanup or reboot, so do not roll back.

### Static configuration

Non-secret static configuration belongs under `/etc`.

The ntfy instance is private, reachable only through the family's Tailscale
network, and intentionally unauthenticated. Configure one non-secret
`ntfy_topic_url` containing the complete publish URL and topic, for example:

`https://ntfy.example.ts.net/nixos-updates`

Combining server and topic avoids unneeded fields. Store static JSON at:

`/etc/evilwoods-update/config.json`

Version 1 contains only `ntfy_topic_url`. The Den aspect generates it; JSON
needs no additional Python parsing dependency and already represents updater
state.

Require exactly `ntfy_topic_url`; reject its absence, unknown fields, or a
non-string value. Strict validation catches misspellings and incompatible
Nix-generated configuration. Invalid notification configuration remains
non-blocking.

Require `ntfy_topic_url` to use `http` or `https`, with a non-empty hostname and
non-root topic path. Reject embedded credentials, queries, and fragments.
Invalid configuration remains non-blocking as described under notification
delivery.

## Notifications

Use Python `requests` to publish host-identifying ntfy notifications for at
least:

- successful staging, including what is ready for the next boot;
- successful staged-to-running promotion after reboot, including what is now
  running;
- failed deployments, including a useful reason;
- transitions into held mode;
- resumption of automatic mode.

Use unambiguous wording for the distinct successes of staging and post-reboot
activation. Automatic notifications identify the FlakeHub release version;
manual ones may identify the store path. Send another staging notification when
a newer automatic release replaces a pending one.

Notify on entry to held mode, every scheduled update that remains held, and
resumption. Repeated held notifications intentionally signal that the host still
needs attention; the systemd timer sets their frequency without another
scheduler. Passive operations such as `status` send no reminders. If
initialization or reconciliation enters held mode and notifies during a
scheduled invocation, omit that invocation's routine reminder.

Notification delivery is best-effort: ntfy failure neither changes deployment
results nor prevents state transitions. Log failures locally. Use a `requests`
timeout tuple of `(5, 10)`, allowing five seconds to connect and ten for a
response. Persistent queues and automatic retries are unnecessary unless missed
notifications become a concrete problem.

Send success notifications only after durable state replacement: mode before
held/resumed, final staged state before staging success, reconciliation before
“now running,” and accepted metadata before “release accepted.” This prevents
claims of unsaved transitions. Post-commit notification failure remains
non-blocking.

Missing or malformed notification configuration is also non-blocking. Without a
valid topic URL, make no HTTP request and log clearly whenever a notification
was due. Updates, staging, reconciliation, `hold`, and `resume` continue;
`status` does not depend on notification configuration.

After posting, call `raise_for_status()` and treat a final non-2xx response as a
best-effort delivery failure. Allow normal `requests` redirects. Log only a
bounded response-body excerpt, not an unbounded response.

Keep normal HTTPS certificate verification. Version 1 has no insecure
`verify = false` or custom bypass; private ntfy trust belongs in host CA
configuration.

Use ntfy priority 3 (default) for staging success, post-reboot activation,
resumption, and routine held reminders; priority 4 (high) for deployment,
discovery, fetch, authentication, or state-write failures and initial entry to
held mode; and priority 5 (urgent) for failed compensating recovery or invalid
state requiring operator repair.

Title every event `NixOS update: <hostname>`. Its body describes the event; its
priority and first line communicate urgency.

Version 1 uses no ntfy tags or emoji; title, plain text, and priority suffice
without per-event tag mappings.

Use concise multiline plain text. The first line describes the event alone,
followed only by relevant fields such as `Release:`, `Revision:`, `System:`, and
`Error:`. Keep JSON and verbose command output in local logs. Show at most the
first 12 Git-revision characters, or the full shorter value; retain the full
revision in state, `status`, and logs. Normalize `Error:` to one line and 500
characters, adding an ellipsis when truncated. Full subprocess output remains
only in local logs.

Use these priority-3 successful staging messages:

```text
Automatic update staged for next boot.
Release: <version>
Revision: <short revision>
System: <store path>
```

```text
Manual system staged for next boot.
System: <store path>
```

Use these priority-3 successful activation-after-reboot messages:

```text
Automatic update is now running.
Release: <version>
Revision: <short revision>
System: <store path>
```

```text
Manual system is now running.
System: <store path>
```

Use this priority-4 message when entering held mode through ordinary operator or
reconciliation behavior:

```text
Automatic updates are now held.
Reason: <operator request, manual staging, external activation, or initialization>
```

Failed recovery uses its separate priority-5 message. Routine timer reminders
use this concise priority-3 body:

```text
Automatic updates remain held.
```

Do not persist a general hold reason only for reminders; detailed history stays
in the journal, while recovery failure remains in the staging intent.

On an actual change back to automatic mode, send this priority-3 message:

```text
Automatic updates resumed.
```

The immediate release check sends a separate staging or failure message when
applicable, but no second message when it makes no deployment or release-metadata
change and encounters no failure.

Use this priority-4 FlakeHub authentication failure message:

```text
Automatic update failed: FlakeHub authentication required.
Action: Run sudo fh login
Error: <concise fh status error>
```

Use these priority-4 discovery and fetch failure messages:

```text
Automatic update failed during release discovery.
Error: <concise error>
```

```text
Automatic update failed while fetching release.
Release: <version>
Revision: <short revision>
Error: <concise error after both attempts>
```

When staging fails but compensation succeeds, use these priority-4 messages:

```text
Automatic update failed while staging.
Release: <version>
Revision: <short revision>
System: <candidate store path>
Recovery: Previous boot configuration restored.
Error: <original staging error>
```

```text
Manual system failed to stage.
System: <candidate store path>
Recovery: Previous boot configuration restored.
Error: <original staging error>
```

Use this priority-5 failed-recovery message:

```text
URGENT: Failed to restore the previous boot configuration.
Operation: <automatic or manual>
Candidate: <candidate store path>
Previous: <previous profile store path>
Original error: <concise original error>
Recovery error: <concise recovery error>
Action: Inspect the system profile and boot configuration manually.
Candidate root: /run/evilwoods-update/candidate retained for inspection.
```

Omit `Candidate root:` when the runtime root was not retained.

The updater remains held, retaining the errors in `staging_intent`.

When a root mutating command finds invalid persistent state, use this priority-5
message:

```text
URGENT: Updater state is invalid.
State: /var/lib/evilwoods-update/state.json
Error: <concise validation error>
Action: Inspect and repair or deliberately remove the state file.
```

Regardless of caller privileges, `status` reports locally without notifying.

Use this priority-4 message for ordinary state-write failures:

```text
Updater state update failed.
Operation: <initialize, reconcile, update, hold, resume, stage, or recover>
Error: <concise write error>
```

For failed `hold`, append `Action: Do not proceed with external activation.`
Other operation-specific consequences remain in CLI or journal output.

Use this priority-4 external activation or rollback message:

```text
Automatic updates are now held.
Reason: External activation or rollback detected.
Expected: <recorded running system>
Observed: <current /run/current-system path>
```

Use this priority-4 initialization message for first installation and deliberate
or accidental state deletion:

```text
Automatic updates are now held.
Reason: Updater state was initialized without prior deployment history.
Running: <current /run/current-system path>
Action: Review the running system, then run sudo evilwoods-update resume
```

The remaining messages follow the same title, priority, and field rules.

Explicit operator hold, priority 4:

```text
Automatic updates are now held.
Reason: Operator requested hold.
```

Hold entered for manual staging, priority 4:

```text
Automatic updates are now held.
Reason: Manual staging requested.
System: <candidate store path>
```

Newer release accepted with an unchanged already-staged system, priority 3:

```text
Newer automatic release accepted; staged system is unchanged.
Release: <version>
Revision: <short revision>
System: <store path>
```

Newer release accepted because its system is already running, priority 3:

```text
Newer automatic release accepted; system is already running.
Release: <version>
Revision: <short revision>
System: <store path>
```

Pending automatic update cancelled because a newer release matches the running
system, priority 3:

```text
Pending automatic update replaced; no system change is pending.
Release: <version>
Revision: <short revision>
System: <running store path>
```

Pending update cancelled through manual staging of the running system, priority
3 (in addition to a held transition message when mode changes):

```text
Pending update cancelled; the current system remains selected for next boot.
System: <running store path>
```

Latest discovered deployment ID is lower than the accepted ID, priority 4:

```text
Automatic update rejected an older latest release.
Discovered ID: <commit count>
Accepted ID: <commit count>
Release: <version>
Revision: <short revision>
```

Temporary candidate cleanup failed after successful staging, priority 4:

```text
Update staged, but temporary fetch-root cleanup failed.
Candidate: /run/evilwoods-update/candidate
Error: <concise cleanup error>
```

Other validation, fetch-result, and operational failures use the closest
template with an event-specific first line and only relevant fields. Do not vary
wording merely by exception type; `Error:` and local logs carry details.

## Main deployer program / CLI

Automatic and manual deployments share one core staging implementation.

Manual deployment coordinates staging an already-present closure with entering
held mode; external activation detection is insufficient. An external
`switch-to-configuration boot` changes next boot without changing
`/run/current-system`, so before reboot the updater could overwrite it
automatically. Manual deployment locks and enters held mode before staging,
immediately exposing and protecting the choice.

Version 1 operations are:

- `update` for the automatic FlakeHub check and staging operation;
- `stage <store-path>` for manual deployment of a specific already-present
  closure;
- `hold` to hold automatic updates;
- `resume` to resume automatic mode and immediately check for an update;
- `status` to inspect updater state.

Only `stage` needs an argument: its store path.

Exit `0` for success, including intentional no-ops such as no newer release or
held `update`; `1` for operational failure; and `2` for usage errors, following
normal argument-parser behavior. Put detailed categories in stderr and local
logs rather than expanding the exit-code API. At the outer boundary, catch
`KeyboardInterrupt`, print a concise message, and return conventional `130`.
This adds no signal-time staging recovery; durable intent handles interrupted
mutation.

Log through Python to stderr, without application-specific files. Systemd
captures scheduled runs in the journal; interactive commands show the same
diagnostics. Log-directory creation, rotation, and retention are out of scope.

Capture external-command stdout and stderr. Log concise progress at `INFO` and
suppress routine successful output. On failure, include useful output in local
logs but send ntfy only a shortened single-line summary.

Invoke external commands with argument lists and `shell=False`; never interpolate
store paths, hostnames, or versions into shell strings. A small helper may
capture output, safely quote commands in logs, and raise a structured error with
exit status and sanitized stderr.

Set no application timeout on `fh fetch`, `nix-env`, or
`switch-to-configuration boot`: duration varies with closure size, network, and
bootloader behavior, while arbitrary termination could require recovery. The
operator or service manager can stop a stuck process; only best-effort ntfy has
an explicit finite timeout.

Version 1 has no custom termination-signal recovery; signal handling across
subprocesses, profile changes, and atomic writes adds risk. After termination
with durable staging intent, the next mutating invocation recovers it before
other work.

The CLI neither invokes `sudo` automatically nor adds a privileged daemon,
socket API, or PolicyKit. For remote manual deployment, the operator connects as
root or invokes the deployer through `sudo`. After parsing, immediately reject
non-root `update`, `stage`, `hold`, and `resume` using `os.geteuid()`, before
opening the lock, initializing state, loading notification configuration, or
running commands. Suggest `sudo` concisely. Only `status` permits non-root use.

Version 1 has no rollback command. The operator instead resolves an older
system-profile generation's store path and manually stages it for next boot. A
bootloader-selected rollback is external activation, which the updater detects
and holds.

From held mode, `resume` transactionally returns to the automatic FlakeHub track
while retaining the lock. Remain held during authentication, discovery, and
fetch. Because a manual system has no trustworthy automatic deployment ID, do
not order it against the release; the latest successfully published release
becomes authoritative. Fetch and validate it even if its ID equals
`latest_automatic_release`, since a different manual system may run or be
pending.

Commit automatic mode only after staging the latest automatic system or
confirming it as the running/next-boot choice. Authentication, discovery, fetch,
validation, staging, or pre-replacement final-commit failure returns failure and
restores or retains held mode, protecting the manual choice. If replacement
succeeds but directory `fsync` fails, follow general durability rules: report
visible automatic mode as durability-uncertain and abort without compensation,
whether or not the profile changed. A `resume` staging intent represents
interruption;
successful recovery returns to held mode. An ID below
`latest_automatic_release` is anomalous and causes `resume` to fail while
remaining held rather than accept rewritten history.

If the fetched system is already pending but marked manual, do not rerun profile
or bootloader commands. Reclassify it as automatic, attach release metadata,
commit automatic mode, and send the resumed notification. Send no staging
notification because the next-boot path did not change.

If the fetched system is running with no different system pending, do not update
the profile or bootloader. Save `latest_automatic_release`, keep
`staged_deployment` null, commit automatic mode, and send only the resumed
notification.

If the fetched automatic system is running but a different manual system is
pending, stage the running system normally to cancel the manual next-boot
choice. Clear `staged_deployment`, save release metadata, and commit automatic
mode. Besides the resumed notification, send priority 3:

```text
Pending manual deployment cancelled; automatic system remains selected.
Release: <version>
Revision: <short revision>
System: <running store path>
```

When resume stages a system different from the running one, retain held mode in
the durable `resume` intent throughout profile and bootloader mutation. On
success, atomically commit automatic mode and automatic `staged_deployment`, then
send `Automatic updates resumed.` and the normal staging-success notification.
Lock-free `status` cannot see automatic mode before final replacement, but may
see complete new state while its directory `fsync` is pending or after failure.

When already automatic, `resume` neither rewrites unchanged mode nor repeats its
transition notification, but performs the normal immediate check while locked.
Equal IDs mean no update. Return the check's result.

`hold` locks and enters held mode without staging, letting the operator prevent
automatic deployment before exceptional external activation such as
`nixos-rebuild switch`. Locking ensures an in-progress automatic deployment
finishes first. Already-held `hold` succeeds without changing state or repeating
the transition notification.

Entering held mode alters neither profile, bootloader, nor staged system. A
pending automatic system remains but later automatic runs cannot replace it; the
operator may use `stage` or exceptional external activation. After reboot,
normal reconciliation promotes it while preserving held mode.

When `update` finds held mode, do not authenticate, discover, fetch, or stage.
Send the held reminder, log, and exit successfully; respecting intentional held
mode is not failure. Omit the reminder if initialization or reconciliation
already sent a held-transition notification this invocation.

`hold` takes effect only after successful atomic replacement. On write failure,
return failure; old state is authoritative only before replacement, while a
post-replacement directory-sync failure leaves visible new mode
durability-uncertain. Send a best-effort failure notification, not transition
success, and clearly warn against the intended external activation.
Transactional `resume` applies the same final-commit durability rules. It stays
or recovers held after pre-replacement failure or compensating recovery; after
post-replacement directory-sync failure, report visible automatic state as
durability-uncertain.

## Remote/manual deployment

The deployer does not transfer closures or orchestrate remote hosts.

The operator explicitly:

1. obtains an already-built local NixOS closure/store path;
2. transfers it with `nix copy` or another appropriate Nix mechanism;
3. invokes remote `stage <store-path>`;
4. lets the deployer lock, validate and stage the present closure for next boot,
   enter held mode, and update state without switching the running session.

Each remote host is authoritative for its `state.json`. Do not edit it remotely;
invoking the target's deployer keeps schema knowledge, locking, validation,
staging, and atomic updates there.

Keeping copying outside the package excludes SSH authentication, remote
addressing, and store transport. Reconsider a convenience wrapper only for a
concrete need.

### Manual candidate validation and mode behavior

Before accepting a manual deployment, validate that:

- the argument resolves to an absolute `/nix/store/...` path;
- the resolved path is a direct child of `/nix/store`, not a file or directory
  inside a store path;
- Nix recognizes it as a valid, realized store path;
- its referenced closure is already present locally;
- it contains an executable `bin/switch-to-configuration`.

After locking, resolve the manual argument once and use that canonical
`/nix/store/...` value for temporary rooting, closure validation, state, profile
mutation, and notifications. Never reuse the original symlink or relative
argument after validation; its target could change between steps.

Manual deployment never fetches missing paths. Validate fully before held mode
or staging intent. Do not recursively hash-verify every closure during every
deployment: cache substitution and `nix copy` already verify imported paths,
while repeated full checks add cost without a concrete need.

A manually copied closure may lack a persistent GC root. After basic path-shape
validation, create a registered temporary root at
`/run/evilwoods-update/candidate` before further validation or profile changes.
Remove it once the system profile roots the candidate or a failed attempt ends.
This prevents a race with concurrent GC. Reuse automatic fetching's cautious
stale-path and cleanup-failure rules; an unregistered symlink is insufficient.

Create the registered manual root with:

`nix-store --realise <store-path> --add-root /run/evilwoods-update/candidate --option substitute false`

For a valid copied path, this creates the runtime symlink and registered auto GC
root. Disabling substitution makes missing or invalid paths fail instead of
fetching implicitly.

After establishing the temporary root, validate the complete local closure with:

`nix path-info --recursive <candidate>`

This neither builds nor substitutes missing paths and fails for an incomplete
closure. Use it in the shared automatic/manual validator, then require executable
`<candidate>/bin/switch-to-configuration`. Do not recursively hash contents.

Every candidate's store-path name after its Nix hash must begin with
`nixos-system-<current-hostname>-`. This repository names each
`nixosConfigurations` output after its host, producing names such as
`nixos-system-<hostname>-26.11...`. This is a practical wrong-host guard, not a
security boundary. Add no bypass without a concrete need for other names.

Get the hostname from `socket.gethostname()` and require only non-emptiness. It
is kernel-controlled, and subprocesses use `shell=False`; unusable FlakeHub
references fail safely. Use this value for the
`nixosConfigurations.<hostname>` output, store-name guard, and notification
titles. Add no configured hostname that could drift from the machine.

Invalid manual input does not affect mode. After successful full validation,
atomically enter held mode before changing the profile. Remain held after
staging failure, including successful compensation, because later automatic
deployment must not silently supersede accepted manual intent.

Manual deployment enters held mode even for the active path, so explicit manual
intervention reliably pauses automatic deployment.

Manual staging preserves `latest_automatic_release`: it changes pending state
and enters held mode without erasing the accepted high-water mark. Later
`resume` retains monotonic protection against older cached releases.

No ordinary operation clears `latest_automatic_release`; preserve it across
`hold`, manual staging, external activation/rollback detection, recovery, and
reboot reconciliation. Only initialization after an absent state file begins
with a null high-water mark.

If a different system is pending and `stage` receives the running path, enter
held mode and stage the running system normally, deliberately cancelling the
pending update. Then clear the staged path because next boot equals the running
baseline, and notify that the current system remains after reboot.

If `stage` receives the running system with no different pending system, persist
held mode without profile or bootloader updates and leave staged path empty.
Report it as already running. Notify only a mode transition, and only if mode
changed; send no staging notification.

Immediate switching is outside this tool. In exceptional situations the
operator may use NixOS activation directly; the updater treats the resulting
path mismatch as external activation and remains held. Because external
activation does not use the updater lock, it should not run concurrently with an
updater operation.

## Automatic-update source/discovery mechanism

FlakeHub supplies automatic deployments. The official CI/CD workflow publishes
a revision only after every CI-selected supported host closure builds and is
pushed to FlakeHub Cache.

The published flake is `sttagent/evilwoods-nixos-config-private`. Discover its
latest release using:

`fh list releases sttagent/evilwoods-nixos-config-private --limit 1 --json`

Keep the repository identifier constant in `flakehub.py`, not configuration.
The deployer already depends on repository-specific output names and release
scheme; configurability would imply unsupported generality.

Use numeric `commit_count` as the automatic deployment ID for monotonic
comparison. Retain full FlakeHub `version` and Git `revision` in state for
status, notifications, and diagnostics. Use returned `simplified_version` only
to construct an exact reference; do not store it. This avoids a separate counter
or metadata service.

### Authentication

The operator, not the NixOS aspect, manages FlakeHub authentication. Authenticate
each host by running root `fh login` with an operator-created token. The
host-local token and its storage are outside both deployer and aspect scope;
neither installs, rotates, nor repairs it. This suits a single operator and small
fleet.

Because tokens expire, verify before every automatic release check, including
transactional `resume`, with:

`fh status`

A held `update` stops before this authentication check.

Without valid authentication, log, notify, and stop the release check. A normal
`update` remains automatic, so the next timer retries after login. Transactional
`resume` remains held, so the operator must rerun it after login. This is a
discovery-step operational failure, not external activation, and cannot itself
enter held mode.

For an automatic release check, whether normal `update` or transactional
`resume`:

1. check FlakeHub authentication with `fh status`; if the host is not
   authenticated, log and notify, then stop (see Authentication);
2. discover the latest release with the command above;
3. compare its `commit_count` with state;
4. construct an exact reference from its `simplified_version` and the current
   hostname, for example
   `sttagent/evilwoods-nixos-config-private/=0.1.2441#nixosConfigurations.evilbook`;
5. run `fh fetch <exact-reference> <runtime-dir>/candidate`;
6. resolve the resulting symlink to the system store path, validate it, and
   stage it;
7. remove the temporary symlink after the standard system profile has become
   the persistent garbage-collector root.

During normal `update`, if discovery returns the accepted ID, treat it as
no-update: log at informational level and exit successfully without fetching,
staging, rewriting state, or notifying.

Reject a discovered ID below the accepted one without fetching or changing
state. Ordinary `update` remains automatic; transactional `resume` remains
held. Log and warn with both IDs and useful release details, then fail. Timer
runs retry later and progress resumes above the accepted ID; a held operator
must deliberately retry `resume`.

Malformed release JSON or missing required fields are a discovery failure.
Without fetching or changing state/mode, log a concise validation error without
excessive raw output, notify with the malformed or missing field, fail, and
let the next timer retry a normal `update`; transactional `resume` requires a
deliberate operator rerun.

A valid empty release list is also a discovery failure, not no-update. With no
candidate metadata, leave mode and state unchanged, send the standard priority-4
discovery failure, and return failure. The next timer retries a normal `update`;
transactional `resume` requires a deliberate operator rerun.

`fh fetch` retrieves the selected output's complete closure, including missing
dependencies, and makes its target symlink a temporary GC root. An exact version
prevents a moving requirement such as `*` from changing releases between
discovery and fetch.

On any nonzero `fh fetch`, preserve mode—automatic for `update`, held for
transactional `resume`—plus staged state and accepted metadata. Remove any
partial candidate symlink, wait 30 seconds, and retry fetch once. Occasional
transient HTTP 503s motivate the retry, but do not parse output to restrict it to
that status. If retry fails, clean the symlink again, log and notify with release
identity and useful error, and return failure. The next timer retries a normal
`update`; transactional `resume` requires a deliberate operator rerun. Do not
restart the systemd service; authentication and discovery need no repeat.

If successful `fh fetch` leaves a candidate that is missing, not a symlink,
outside `/nix/store`, or otherwise invalid, fail the result without immediate
retry. Do not write staging intent, touch profile/bootloader, or change mode,
staged state, or accepted metadata. Remove only a symlink candidate, log and
send a priority-4 failure. The next timer retries a normal `update`;
transactional `resume` requires a deliberate operator rerun.

After successful fetch, require `/run/evilwoods-update/candidate` itself to be a
symlink and resolve it once. Use the canonical path throughout validation and
staging instead of refollowing the mutable symlink; cleanup still removes the
original link.

Version 1 assumes published history is not intentionally rewritten. Jujutsu
protects pushed history from ordinary rewriting unless explicitly overridden.
A lower commit count is rejected, potentially pausing automatic progress until
the count exceeds the accepted value. An equal commit count is treated as the
same deployment ID: ordinary `update` is a no-op, while transactional `resume`
may re-fetch it. Version 1 does not try to detect changed release metadata at an
equal ID.

A possible version 2 could treat FlakeHub's `rolling-minor` as an epoch and
compare `(rolling_minor, commit_count)`, allowing intentional history reset from,
for example, `0.1.2441` to `0.2.120`. Version 1 needs no such complexity.

## Deployment / activation mechanism

The deployer stages candidate NixOS system store paths.

Both deployment types install the candidate for next boot without switching the
running configuration; it activates only after reboot. Manual deployment also
enters held mode.

Stage an already-present system closure using the standard NixOS sequence:

1. `nix-env --profile /nix/var/nix/profiles/system --set <store-path>`
2. `<store-path>/bin/switch-to-configuration boot`

Updating the standard profile creates a normal NixOS generation with usual
bootloader rollback entries. Candidate `switch-to-configuration boot` updates
boot configuration without switching the running system. FlakeHub-fetched and
manually copied closures share this staging implementation; fetching is
separate.

Remember the profile target before changing it. After a failed candidate set,
resolve it again. If unchanged, no bootloader command ran and compensation is
unnecessary; clear intent using the operation's failure mode and report failure.
If changed or unreadable, attempt full compensation. Also compensate when the
profile set succeeds but candidate `switch-to-configuration boot` fails, by
restoring the previous target and running its `switch-to-configuration boot`.
Record staged state only after both candidate steps succeed.

When profile setting fails but remains unchanged, use the normal priority-4
staging failure without `Recovery:`; logs show compensation was unnecessary.
When attempted, use the existing successful/failed recovery templates.

After successful compensation, report the original staging failure. Ordinary
`update` leaves automatic state unchanged; accepted manual `stage` or
transactional `resume` remains or returns held. If compensation fails, enter
held mode, log both failures, notify at priority 5, and require inspection.
Because bootloader updates may partially fail, perfect atomicity cannot be
guaranteed; restoring the previous known boot configuration is safest.

During recovery, restore the previous profile before its
`switch-to-configuration boot`. If restoration fails, do not run the bootloader
step while the profile points elsewhere; stop, latch urgent recovery failure,
and identify profile restoration as the failed step. If only the bootloader step
fails, latch that failure normally.

Final atomic state replacement is part of staging. If it fails before
replacement after installing candidate profile and boot configuration, fail the
deployment and immediately compensate to the previous configuration. Retain
staging intent until recovery and its clearing update both succeed. If clearing
fails after recovery, leave intent so the next invocation repeats recovery
conservatively.

If final state replacement succeeds but directory `fsync` fails, visible state
already matches installed profile and boot configuration. Report it as
durability-uncertain and abort without compensation or success notification.
The next mutation anchors the visible rename during startup sync. If sudden
power loss instead rolls state back to staging intent, normal interrupted-intent
recovery restores the previous configuration.

## Important invariants

- Automatic and manual deployment paths never run concurrently or switch the
  running session; both stage for next boot.
- Older cached automatic deployments never silently replace a manual deployment
  or rollback.
- Detect an external activation/rollback and enter held mode when the observed
  system matches neither the running baseline nor updater-staged system.
- Only explicit `resume` exits held mode.
- Accepted manual deployment enters held mode even when its path is active or
  subsequent staging fails.
- No ordinary updater operation decreases or clears the accepted automatic
  deployment-ID high-water mark: new releases strictly increase it, while
  `resume` may reuse it.
- FlakeHub's numeric `commit_count` orders automatic deployments; full version
  and revision identify them for humans.
- Only CI revisions successfully published to FlakeHub qualify for automatic
  deployment.
- State survives reboots; the lock and temporary fetch root do not need to.
- `/etc` is for static configuration, `/var/lib/...` for mutable persistent
  state, and `/run/...` for runtime-only synchronization and temporary roots.
- The remote target manages its deployment state; clients do not edit it.
- Notification failure never changes the deployment or state-operation result.

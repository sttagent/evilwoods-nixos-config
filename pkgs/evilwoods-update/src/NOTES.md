# NixOS cache deployer — project notes

These are working project notes, not a finished requirements document.

## Established requirements

The script should pull a host’s prebuilt NixOS closure from the binary cache and apply it automatically, while also supporting a closure pushed manually over SSH.

It must never overwrite a manual deployment with an older cached build:

- manual deployments and rollbacks should switch the updater from automatic mode to held mode until explicitly resumed;
- automatic deployments should accept only monotonically newer deployment IDs.

Persistent state—including the mode, current store path or revision, and last automatic deployment ID—should live in:

`/var/lib/state-dir-created-by-systemd/state.json`

Optional configuration belongs in `/etc`.

Automatic and manual operations should share a `flock` lock at:

`/run/runtime-dir-created-by-systemd/update.lock`

so they cannot deploy concurrently.

## Repository / source-side inventory

The files will live in the existing NixOS configuration repository.

### Python project

- `pyproject.toml`
  - The deployer will be a Python project/package.
  - The Python project will later be converted into a Nix package derivation.

- Python package source files
  - Exact package/module names and layout are still undecided.
  - The same package should contain the target-host deployment logic and, if practical, the client/orchestration logic for pushing to another host.

- Tests
  - Exact files and test layout are undecided.

### Nix / Den integration

- A Den aspect will contain the NixOS/systemd integration.
- Systemd service/timer files do not need to exist as standalone source files if they are declared directly through NixOS configuration in the aspect.
- The aspect will eventually need to arrange at least:
  - installation of the Python package;
  - the automatic update service;
  - the timer for automatic update;
  - creation/ownership of the persistent state directory;
  - creation/ownership of the runtime directory used for the lock;
  - any static configuration the deployer needs.

Exact aspect path/name and exact Nix file layout are still undecided.

## Files/directories created or used on a deployed host

### Persistent state

`/var/lib/state-dir-created-by-systemd/state.json`

It needs to represent at least:

- updater mode: automatic or held;
- current deployed system store path and/or revision;
- last successfully applied automatic deployment ID.

Potentially useful additional state can be added later, but should not be invented until there is a concrete need.

### Runtime lock

`/run/runtime-dir-created-by-systemd/update.lock`

Every operation capable of changing deployment state or the active system must coordinate through this lock.

### Optional configuration

Static configuration may live under `/etc`.

Whether there is actually a configuration file, what it is called, and what belongs in it are still undecided. Some or all configuration may instead be supplied declaratively by the Den/NixOS aspect as command-line arguments or environment.

## Main deployer program / CLI

Automatic and manual deployments should go through the same core deployment logic rather than having two independent implementations.

Operations that appear necessary so far:

- automatic update;
- manual deploy of a specific closure;
- resume automatic mode;
- status;
- rollback/manual switch, if rollback is handled by this tool.

Exact subcommand names and arguments are still undecided.

## Remote/manual deployment direction

It would be useful if the same deployer could initiate a deployment to another host.

Current preferred direction:

1. A local instance is given an already-built NixOS closure/store path.
2. The local instance transfers the closure to the remote host using Nix tooling.
3. The local instance invokes the deployer on the remote host over SSH.
4. The remote instance acquires its own deployment lock, performs the deployment, and updates its own state.

The remote host should be authoritative for its own `state.json`.

The local instance should not normally edit the remote `state.json` directly. Calling the remote deployer keeps state-schema knowledge, locking, validation, activation, and atomic state updates on the target side.

For transferring Nix store paths, direct Nix commands are currently preferred over depending on `nh`. `nh` may remain useful interactively, but the deployer probably does not need it as a runtime dependency.

The exact Nix command/transport is still undecided; `nix copy` over an SSH store transport is one likely option.

## Automatic-update source/discovery mechanism

There must be a deterministic way for a host to discover:

- the NixOS closure intended for that host;
- its deployment ID;
- enough information to fetch/substitute the closure from the binary cache.

The concrete mechanism is still undecided.

The important invariant is that automatic deployment IDs move only forward and old/equal automatic deployments are not accidentally applied after newer or manual deployments.

## Deployment / activation mechanism

There must be one implementation responsible for taking a candidate NixOS system store path and making it the active system configuration.

Still undecided:

- exact activation command(s);
- boot-generation handling;
- whether the tool supports `switch`, `boot`, or both;
- exact failure behavior.

## Failure / atomicity questions still to design

We still need explicit rules for what happens when:

- fetching or copying a closure fails;
- validation fails;
- activation fails partway through;
- writing the state file fails;
- the process is interrupted;
- the candidate is already active;
- an automatic deployment ID is old/equal;
- the automatic updater runs while mode is held.

State-file replacement should probably be atomic, but the transaction boundary between activation and state updates still needs to be designed.

## Important invariants so far

- Automatic and manual deployment paths never run concurrently.
- A manual deployment or rollback cannot later be silently replaced by an older cached automatic deployment.
- Held mode is exited only by an explicit resume operation.
- Automatic deployment IDs only move forward.
- State survives reboots; the lock does not need to.
- `/etc` is for static configuration, `/var/lib/...` for mutable persistent state, and `/run/...` for runtime-only synchronization state.
- The remote target should manage its own deployment state rather than having a client edit that state file directly.

## Open design decisions

- Exact Python package/module/file layout.
- Exact CLI/subcommand names and arguments.
- Whether `push` accepts only an already-built `/nix/store/...` path or can also build a flake output itself.
- Exact JSON state schema and whether to version it.
- How a host discovers the latest cached deployment and deployment ID.
- What a deployment ID actually is.
- Exact Nix command/SSH transport for pushing a closure.
- Exact NixOS activation command and boot-generation behavior.
- Whether rollback is implemented directly by this tool.
- Whether `resume` immediately checks for an update or only enables the next timer run.
- Whether any `/etc` configuration file is needed at all.
- Privilege model.
- Exact Den aspect name/path and repository layout.

# Deduplication Opportunities

## High Priority (High Impact, Low Effort)

### 1. User@Host Module Factory
Each `userX@hostY` module follows the same pattern:
- Imports base user module
- Sets sops age key path
- Configures home-manager with sops module

**Action:** Create a `mkUserHostModule` function in lib that takes `{ user, host, extraConfig }` and generates this boilerplate. This would reduce each user@host module to just the host-specific programs/settings.

### 2. NFS Share Configuration Factory
`aitvarasMachines` and `ryneMachines` have nearly identical structure (fileSystems, systemd automounts, group creation). Only the mount paths, UIDs, and GIDs differ.

**Action:** Create a `mkNfsShares` function that takes a list of share definitions `{ name, path, gid, uid, ... }` and generates all the fileSystems/automount/group configurations.

### 3. User Creation with Sops Pattern
The pattern of creating users with sops-encrypted passwords appears in multiple user modules with identical structure (users.users.X.hashedPasswordFile → config.sops.secrets.X-password.path).

**Action:** Create a `mkSopsUser` helper that takes user attributes plus sops secret name and generates both the user definition and sops secret declaration.

## Medium Priority

### 4. Service Module Template
The evilcloud services follow a consistent pattern:
- Options declaration for enable/port/domain
- Conditional config based on `cfg.enable`
- Traefik integration labels

**Action:** Create a `mkService` helper that generates this structure, taking service-specific configuration as an argument.

### 5. Home-Manager Program Configurations
Programs like `git`, `fish`, `starship`, `zoxide`, `eza`, `direnv` appear in user configs with similar settings across users.

**Action:** Create a `programs/` module directory under `common/` that defines reusable program configurations (e.g., `mkGitConfig`, `mkFishConfig`) that can be imported and customized per user.

## Lower Priority

### 6. Hardware Module Integration
`hardwareZSA` and `hardwareAndroid` are small but follow the same pattern. If more hardware modules are added, consider:
```nix
mkHardwareModule { name, packages, groups ? [], udevRules ? [] }
```

### 7. Host Configuration Files Structure
Each host has similar files (`configuration.nix`, `hardware.nix`, `network.nix`, `packages.nix`). While content differs, structure is identical.

**Action:** Consider a `mkHost` function that expects these files in a directory and auto-imports them, reducing explicit imports in each host's main module.

### 8. Editor Configurations in User Modules
The `aitvaras@evilbook` module has multiple editor configs (helix, neovim) with some disabled. If users switch editors across hosts, consider making editor choice an option rather than duplicating configs.

### 9. Desktop Environment Base Packages
`gnome.nix` has more package configuration than `cosmic.nix`. Some packages are likely common to all desktop environments.

**Action:** Move truly common desktop packages (browser, file manager, etc.) to the base `desktop` module, leaving DE-specific modules for only DE-specific tooling.

{
  imports = [
    ../common/core

    ./boot.nix
    (import ./partitions.nix { })
    ./hardware.nix
    ./configuration.nix

    # Services
    ./services/samba.nix
    ./services/caddy.nix
    ./services/acme.nix
    ./services/postgresql.nix
    ./services/atuin.nix
    ./services/languagetool.nix
    ./services/kitchenowl.nix
    ./services/restic-backup.nix
  ];
}

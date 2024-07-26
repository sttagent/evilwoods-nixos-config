{
  imports = [
    ../common/core

    ./boot.nix
    (import ./partitions.nix { })
    ./hardware.nix
    ./configuration.nix

    # Services
    ./services/samba.nix
    ./services/postgresql.nix
    ./services/atuin.nix
    ./services/ntfy.nix
    ./services/languagetool.nix
    ./services/kitchenowl.nix
  ];
}

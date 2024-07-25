{ lib
, pkgs
, ...
}: {
  imports = [
    ../common/core

    (import ./partitions.nix { })
    ./hardware.nix
    ./configuration.nix

    # Services
    ./services/blocky.nix
    ./services/samba.nix
    ./services/postgresql.nix
    ./services/atuin.nix
    ./services/ntfy.nix
    ./services/languagetool.nix
  ];
}

{ lib
, pkgs
, ...
}: {
  imports = [
    ../common/core

    (import ./evilcloud-partition-scheme.nix { })
    ./evilcloud-hardware-configuration.nix
    ./evilcloud-configuration.nix

    # Services
    ./samba.nix
    ./postgresql.nix
    ./atuin.nix
    ./ntfy.nix
    ./languagetool.nix
  ];
}

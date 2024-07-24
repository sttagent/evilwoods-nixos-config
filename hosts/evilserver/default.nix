{ lib
, pkgs
, ...
}: {
  imports = [
    ../common/core

    (import ./evilserver-partition-scheme.nix { })
    ./evilserver-hardware-configuration.nix
    ./evilserver-configuration.nix

    # Services
    ./blocky.nix
    ./samba.nix
    ./postgresql.nix
    ./atuin.nix
    ./ntfy.nix
    ./languagetool.nix
  ];
}

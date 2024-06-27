{ lib
, pkgs
, ...
}: {
  imports = [
    ./evilcloud-partition-scheme.nix
    ./evilcloud-configuration.nix
    ./evilcloud-home.nix
  ];
}

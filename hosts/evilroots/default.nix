{ lib
, pkgs
, ...
}: {
  imports = [
    ./evilroots-configuration.nix
    ./evilroots-partition-scheme.nix
    ./evilroots-home.nix
  ];
}

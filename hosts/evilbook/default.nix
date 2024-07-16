{ lib
, pkgs
, ...
}: {
  imports = [
    ../common
    ./evilbook-partition-scheme.nix
    ./evilbook-hardware-configuration.nix
    ./evilbook-configuration.nix
    ./evilbook-packages.nix
    # ./evilbook-home-hyprland.nix
  ];
}

{ lib
, pkgs
, ...
}: {
  imports = [
    ../common/core
    ../common/desktop

    ./evilbook-partition-scheme.nix
    ./evilbook-hardware-configuration.nix
    ./evilbook-configuration.nix
    ./evilbook-packages.nix
    # ./evilbook-home-hyprland.nix
  ];
}

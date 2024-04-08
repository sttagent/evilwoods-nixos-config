{ lib
, pkgs
, ...
}: {
  imports = [
    ./evilbook-partition-scheme.nix
    ./evilbook-hardware-configuration.nix
    ./evilbook-configuration.nix
    ./evilbook-home.nix
    ./evilbook-home-nvim.nix
    # ./evilbook-home-hyprland.nix
  ];
}

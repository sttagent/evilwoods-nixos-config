{ lib
, pkgs
, ...
}: {
  imports = [
    ./evilbook-partition-scheme.nix
    ./evilbook-configuration.nix
    ./evilbook-home.nix
    ./evilbook-home-nvim.nix
    # ./evilbook-home-hyprland.nix
  ];
}

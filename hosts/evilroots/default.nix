{ lib
, pkgs
, ...
}: {
  imports = [
    ./evilroots-configuration.nix
    ./evilroots-partition-scheme.nix
    ./evilroots-home.nix
    ./evilroots-home-nvim.nix
    ./evilroots-home-hyprland.nix
  ];
}

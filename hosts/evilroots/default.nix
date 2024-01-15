{ lib
, pkgs
, ...
}: {
  imports = [
    ./evilroots-partition-scheme.nix
    ./evilroots-configuration.nix
    ./evilroots-home.nix
    ./evilroots-home-nvim.nix
    # ./evilroots-home-hyprland.nix
  ];
}

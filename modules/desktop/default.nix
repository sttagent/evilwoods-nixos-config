{ config, pkgs, lib, ... }: {
  imports = [
    ./shared-desktop-configuration.nix
    ./gnome.nix
    ./hyprland.nix
    ./steam.nix
    ./moonlander.nix
  ];
}

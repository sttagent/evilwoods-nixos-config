{ config, pkgs, lib, ... }: {
  imports = [
    ./shared-desktop-configuration.nix
    ./gnome.nix
    ./steam.nix
    ./zsa.nix
  ];
}

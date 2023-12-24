{ config, pkgs, lib, ... }: {
  imports = [
    ./shared-desktop-configuration.nix
    ./moonlander.nix
    ./steam.nix
  ];
}

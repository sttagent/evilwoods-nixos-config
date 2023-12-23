{ config, pkgs, lib, ... }:

{
  imports = [
    ./base
    ./desktop
    ./graphics
    ./shared-packages.nix
    ./virtualisation.nix
  ];
}

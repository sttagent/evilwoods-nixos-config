{ config, pkgs, lib, ... }:

{
  imports = [
    ./shared
    ./desktop
    ./graphics
    ./virtualisation.nix
  ];
}

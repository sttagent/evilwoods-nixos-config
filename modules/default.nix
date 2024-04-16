{ config, pkgs, lib, ... }:

{
  imports = [
    ./base
    ./desktop
    ./graphics
    ./virtualisation.nix
  ];
}

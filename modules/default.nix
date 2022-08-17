{config, pkgs, lib, ...}:

{
  imports = [
    ./core
    ./desktop
    ./graphics
    ./virtualisation.nix
  ];
}

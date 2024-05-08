{ config, ... }:
{
  imports = [
    ./packages.nix
    ./core.nix
    ./desktop.nix
  ];
}

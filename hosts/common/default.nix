{ config, ... }:
{
  imports = [
    ./packages.nix
    ./core.nix
    ./tailscale.nix
    ./desktop.nix
  ];
}

{
  config,
  pkgs,
  lib,
  ...
}:

# Config for moonlander keyboard.

let
  inherit (lib) mkEnableOption mkIf;
  zsa = config.evilwoods.hardware.zsa;
in
{

  options.evilwoods.hardware.zsa.enabled = mkEnableOption "ZSA";

  config = mkIf zsa.enabled {

    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = with pkgs; [
      wally-cli
      keymapp
    ];
  };
}

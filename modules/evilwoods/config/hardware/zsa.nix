{
  config,
  pkgs,
  lib,
  ...
}:

# Config for moonlander keyboard.

let
  inherit (lib) mkEnableOption mkIf;
  zsa = config.evilwoods.config.zsa;
in
{

  options.evilwoods.config.zsa.enable = mkEnableOption "ZSA";

  config = mkIf zsa.enable {

    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = with pkgs; [
      wally-cli
      keymapp
    ];
  };
}

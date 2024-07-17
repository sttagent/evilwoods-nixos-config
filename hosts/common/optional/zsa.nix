{ config, pkgs, lib, ... }:

# Config for moonlander keyboard.

with lib;

let
  zsa = config.evilwoods.zsa;
in
{

  options.evilwoods.zsa = mkEnableOption "ZSA";

  config = mkIf zsa {

    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = with pkgs; [ wally-cli keymapp ];
  };
}

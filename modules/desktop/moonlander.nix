{ config, pkgs, lib, ... }:

# Config for moonlander keyboard.

with lib;

let
  zsa = config.evilcfg.zsa;
in {

  options.evilcfg.zsa = mkEnableOption "ZSA";

  config = mkIf zsa {

    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = with pkgs; [ wally-cli ];
  };
}

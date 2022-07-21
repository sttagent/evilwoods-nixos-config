{ config, pkgs, lib, ... }:

# Config for moonlander keyboard.

let
  moonlander = config.sys.zsa.enable;
in {

  config = mkIf moonlander {

    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = with pkgs; [ wally-cli ];
  };
}

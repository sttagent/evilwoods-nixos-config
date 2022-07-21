{ config, pkgs, lib, ... }:

# Config for moonlander keyboard.

let
  moonlander = cofig.sys.zsa.enable;
in {

  config = mkIf moonlander {

    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = with pkgs; [ wally-cli ];
  };
}

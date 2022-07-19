{ config, pkgs, lib, ... }:

# Config for moonlander keyboard.

{
  config = {
    hardware.keyboard.zsa.enable = true;

    environment.systemPackages = with pkgs; [ wally-cli ];
  };
}

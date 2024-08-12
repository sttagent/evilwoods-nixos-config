{ config, pkgs, ... }:
let
  mainUser = config.evilwoods.mainUser;
in
{
  users.users.${mainUser}.extraGroups = [ "adbusers" ];
  programs.adb.enable = true;
  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}

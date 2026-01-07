{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  mainUser = config.evilwoods.base.mainUser;
  cfg = config.evilwoods.hardware.android;
in
{
  options.evilwoods.hardware.android.enabled = mkEnableOption "android config";

  config = mkIf cfg.enabled {
    users.users.${mainUser}.extraGroups = [ "adbusers" ];
    environment.systemPackages = with pkgs; [
      android-tools
    ];
  };
}

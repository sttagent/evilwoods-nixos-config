{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  mainUser = config.evilwoods.flags.mainUser;
  cfg = config.evilwoods.hardware.android;
in
{
  options.evilwoods.hardware.android.enabled = mkEnableOption "android config";

  config = mkIf cfg.enabled {
    users.users.${mainUser}.extraGroups = [ "adbusers" ];
    programs.adb.enable = true;
  };
}

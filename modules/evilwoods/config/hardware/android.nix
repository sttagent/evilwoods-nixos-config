{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  mainUser = config.evilwoods.flags.mainUser;
  cfg = config.evilwoods.config.android;
in
{
  options.evilwoods.config.android.enable = mkEnableOption "android config";

  config = mkIf cfg.enable {
    users.users.${mainUser}.extraGroups = [ "adbusers" ];
    programs.adb.enable = true;
  };
}

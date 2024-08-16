{ lib, ... }:
let
  inherit (lib) types mkOption;
in{
  options = {
    evilwoods = {
      mainUser = mkOption {
        type = types.str;
        default = "aitvaras";
        description = "The primary user of evilwoods.";
      };

      isTestEnv = mkOption {
        type = types.bool;
        default = false;
        description = "Enable or dirable testing environment";
      };

    };
  };
}

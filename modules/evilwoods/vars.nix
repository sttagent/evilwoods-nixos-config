{ lib, ... }:
{
  options = {
    evilwoods = {
      mainUser = lib.mkOption {
        type = lib.types.str;
        default = "aitvaras";
        description = "The primary user of evilwoods.";
      };

      isTestEnv = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable or dirable testing environment";
      };

    };
  };
}

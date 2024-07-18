{ lib, ... }:
{
  options = {
    evilwoods = {
      mainUser = lib.mkOption {
        type = lib.types.str;
        default = "aitvaras";
        description = "The primary user of evilwoods.";
      };

      currentHost = lib.mkOption {
        type = lib.types.str;
        default = "evilwoods";
        description = "The current host name.";
      };
    };
  };
}

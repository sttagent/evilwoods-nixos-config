{ self, lib, ... }:
let
  inherit (lib) types mkOption;
in
{
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

      tailscaleIP = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Tailscale IP address";
      };
      
      configPath = mkOption {
        type = types.path;
        default = self.outPath + "/hosts/config";
        description = "Path to the configuration directory";
      };

    };
  };
}

{ self, lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    evilwoods = {
      vars = {
        mainUser = mkOption {
          type = types.str;
          default = "aitvaras";
          description = "The primary user of evilwoods.";
        };

        isTestEnv = mkOption {
          type = types.bool;
          default = false;
          description = "Enable or disable testing environment";
        };

        configPath = mkOption {
          type = types.path;
          default = self.outPath + "/hosts/config";
          description = "Path to the configuration directory";
        };

        tailscaleIP = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Tailscale IP address";
        };

        domain = mkOption {
          type = types.str;
          default = "evilwoods.net";
          description = "Domain name";
        };

        shell = mkOption {
          type = types.str;
          default = "xonsh";
          description = "Default shell";
        };
      };
    };
  };
}

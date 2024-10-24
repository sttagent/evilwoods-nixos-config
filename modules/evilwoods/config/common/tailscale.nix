{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    mkEnableOption
    types
    ;

  mainUser = config.evilwoods.vars.mainUser;
  isTestEnv = config.evilwoods.vars.isTestEnv;
  cfg = config.evilwoods.config.tailscale;
in
{
  options.evilwoods.config.tailscale.enable = mkEnableOption "enable Tailscale";

  config = mkIf cfg.enable (mkMerge [
    {
      # tailscale configuration
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
      services = {
        tailscale = {
          enable = true;
          useRoutingFeatures = "client";
          extraUpFlags = [
            "--ssh"
            "--operator=${mainUser}"
          ];
        };
      };
    }

    (mkIf (!isTestEnv) {
      sops.secrets.tailscale-auth-key = { };
      services.tailscale.authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    })

    (mkIf isTestEnv {
      sops.secrets.tailscale-ephemeral-auth-key = { };
      services.tailscale.authKeyFile = config.sops.secrets.tailscale-ephemeral-auth-key.path;
    })
  ]);
}

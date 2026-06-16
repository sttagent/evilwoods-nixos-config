{
  den.aspects.hostBase.nixos =
    {
      host,
      config,
      lib,
      ...
    }:
    let
      inherit (lib)
        mkIf
        mkMerge
        ;

      tailscaleExtraUpFlags = [
        "--ssh"
        "--operator=${host.mainUser}"
      ];
    in
    {
      # tailscale configuration
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
      services = {
        tailscale = {
          enable = true;
          useRoutingFeatures = "client";
          extraUpFlags = tailscaleExtraUpFlags;
        };
      };

      sops.secrets.tailscale-auth-key = { };
      services.tailscale.authKeyFile = config.sops.secrets.tailscale-auth-key.path;
    };
}

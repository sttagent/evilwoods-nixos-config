# The file is not imported by default

{ config, lib, pkgs, ... }:
{
  imports = [ ./default.nix ];

  sops.secrets.tailscale-ephemeral-auth-key = { };
  services.tailscale.authKeyFile = lib.mkForce config.sops.secrets.tailscale-ephemeral-auth-key.path;
  
  users.users.nixostest = {
    isNormalUser = true;
    password = "test";
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
  };
  
  virtualisation.vmVariant.virtualisation = {
    sharedDirectories = {
        keys = {
          source = "/etc/ssh";
          target = "/etc/ssh";
        };
    };
  };
  
}

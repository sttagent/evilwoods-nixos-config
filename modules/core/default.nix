{ config, pkgs, lib, ...}:

with lib;

let
  ssh = config.evilcfg.ssh;
in {
  imports = [
    ./core-packages.nix
    ./users
  ];

  options.evilcfg.ssh = mkEnableOption "ssh";
  
  config = {
    networking.networkmanager.enable = true;

    # Tailscale
    services.tailscale.enable = true;
    networking.firewall = {
      checkReversePath = "loose"; # Recommended by wiki for tailscale
      trustedInterfaces = [ "tailscale0" ];
    };

    services.openssh = mkIf ssh {
      enable = true;
    };

    programs.fish.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Stockholm";

    # Select internationalisation properties.
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "sv_SE.UTF-8";
        LC_IDENTIFICATION = "sv_SE.UTF-8";
        LC_MEASUREMENT = "sv_SE.UTF-8";
        LC_MONETARY = "sv_SE.UTF-8";
        LC_NAME = "sv_SE.UTF-8";
        LC_NUMERIC = "sv_SE.UTF-8";
        LC_PAPER = "sv_SE.UTF-8";
        LC_TELEPHONE = "sv_SE.UTF-8";
        LC_TIME = "sv_SE.UTF-8";
      };
    };
  };
}

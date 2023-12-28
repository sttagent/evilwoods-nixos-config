{ config, lib, pkgs, inputs, ... }:
let
  mainUser = config.evilcfg.mainUser;
in
with lib; {
  config = {
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
        trusted-users = ${mainUser}
      '';

      # Garbage collection
      gc = {
        automatic = mkDefault true;
        dates = mkDefault "weekly";
        options = mkDefault "--delete-older-than 30d";
      };
    };

    nixpkgs.config.allowUnfree = true;
    

    boot = {
      loader.systemd-boot.configurationLimit = mkDefault 100;
      kernelPackages = pkgs.linuxPackages_latest;
    };

    # disable user creation. needed to disable root account
    users.mutableUsers = false;
    # disable root account
    users.users.root.hashedPassword = "!";

    networking = {
      useDHCP = mkDefault true;
      networkmanager = {
        enable = true;
      };
      firewall = {
        enable = true;
      };
    };

    programs.fish.enable = true;

    # nextdns configuration
    networking = {
      nameservers = [ "45.90.28.0#c9d65a.dns.nextdns.io" "45.90.30.0#c9d65a.dns.nextdns.io" ];
    };
    services = {
      resolved = {
        enable = true;
        dnssec = "false";
        domains = [ "~." ];
        fallbackDns = [ "45.90.28.0#c9d65a.dns.nextdns.io" "45.90.30.0#c9d65a.dns.nextdns.io" ];
        extraConfig = ''
          DNSOverTLS=yes
        '';
      };
    };


    # tailscale configuration
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    services = {
      tailscale = {
        enable = true;
        useRoutingFeatures = "client";
      };
    };

    time.timeZone = "Europe/Stockholm";

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

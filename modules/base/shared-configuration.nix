{ lib, pkgs, inputs, ... }: {
  config = {
    # disable user creation. needed to disable root account
    users.mutableUsers = false;
    # disable root account
    users.users.root.hashedPassword = "!";

    networking = {
      networkmanager.enable = true;
      firewall = {
        enable = true;
      };
    };

    programs.fish.enable = true;

    # nextdns configuration
    networking.nameservers = [ "45.90.28.0#c9d65a.dns.nextdns.io" "45.90.30.0#c9d65a.dns.nextdns.io" ];
    services = {
      resolved = {
        enable = true;
        dnssec = "true";
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
        useRoutingFeatures = "both";
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

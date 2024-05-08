{ inputs, config, pkgs, lib, ... }:
let
  mainUser = config.evilwoods.mainUser;
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      trusted-users = ${mainUser}
    '';

    # Garbage collection
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot = {
    loader.systemd-boot.configurationLimit = lib.mkDefault 100;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    validateSopsFiles = false;
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = lib.mkDefault true;
    };
  };

  time.timeZone = "Europe/Stockholm";

  services = {
    openssh = {
      enable = true;
    };
  };

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

  # disable user creation. needed to disable root account
  users.mutableUsers = false;
  # disable root account
  users.users.root.hashedPassword = "!";

  programs.fish.enable = true;
}

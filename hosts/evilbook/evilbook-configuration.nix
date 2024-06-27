{ config, lib, pkgs, thisHost, ... }:
{
  evilwoods.enableGnome = true;
  #evilwoods.steam = true;
  evilwoods.zsa = true;
  evilwoods.podman = true;
  # evilwoods.docker = true;
  # evilwoods.libvirtd = true;
  # evilwoods.enableHyprland = true;

  sops.secrets = {
    "network-manager.env" = { };
  };

  networking.hostName = "${thisHost.hostname}";

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [ config.sops.secrets."network-manager.env".path ];
    profiles = {
      evilwoods-5G = {
        connection = {
          id = "evilwoods-5G";
          uuid = "006294ff-83a7-44e1-ac14-49c08b44cc05";
          type = "wifi";
          interface-name = "wlp1s0";
          autoconnect = true;
        };
        wifi = {
          mode = "infrastructure";
          ssid = "evilwoods-5G";
        };
        wifi-security = {
          auth-alg = "open";
          key-mgmt = "wpa-psk";
          psk = "$evilwoods_psk";
        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          addr-gen-mode = "default";
          method = "auto";
        };
        proxy = { };
      };
    };
  };

  boot = {
    initrd = {
      verbose = false;
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
    };
  };

  programs.nix-ld = {
    enable = true;
  };

  # LTU VPN
  # services.strongswan.enable = true;
  # networking.networkmanager.enableStrongSwan = true;


  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = thisHost.stateVersion; # Did you read the comment?
}

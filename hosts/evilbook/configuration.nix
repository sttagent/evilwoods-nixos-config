{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common/optional/base
    ../common/optional/desktop
    ../common/optional/gnome
    ../common/optional/zsa.nix

    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
  ];
  sops.secrets = {
    "network-manager.env" = { };
  };

  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
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
  };

  boot = {
    initrd = {
      verbose = false;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  virtualisation = {
    podman = {
      enable = true;
    };
    vmVariant = {
      virtualisation = {
        memorySize = 4096;
        cores = 2;
      };
    };
  };

  programs.nix-ld = {
    enable = true;
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

{
  inputs,
  config,
  pkgs,
  modulesPath,
  configPath,
  ...
}:
{
  imports = [
    (configPath + "/common")
    (configPath + "/hardware/boot/systemd-boot.nix")
    (configPath + "/desktop")
    (configPath + "/gnome")
    (configPath + "/optional/zsa.nix")
    (configPath + "/optional/android.nix")

    # (modulesPath + "/profiles/perlless.nix")

    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    # (modulesPath + "/profiles/perlless.nix")
  ];

  services.userborn.enable = true;
  # system.etc.overlay.enable = true;

  system.stateVersion = "24.05";

  # host specific variables
  evilwoods.vars = {
    tailscaleIP = "100.68.177.122";
  };

  sops.secrets = {
    "network-manager.env" = { };
  };

  programs.steam.enable = true;
  programs.command-not-found.enable = false;

  networking.wireless.iwd.enable = true;
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    ensureProfiles = {
      environmentFiles = [ config.sops.secrets."network-manager.env".path ];
      profiles = {
        evilwoods-5G = {
          connection = {
            id = "evilwoods-5G";
            type = "wifi";
            interface-name = "wlan0";
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
      systemd.enable = true;
    };

    tmp.useTmpfs = true;

    kernelPackages = pkgs.linuxPackages_latest;
  };

  systemd.services.nix-deamon = {
    environment.TMPDIR = "/var/tmp";
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

{
  inputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    # (modulesPath + "/profiles/perlless.nix")
  ];

  # host specific variables
  evilwoods = {
    config = {
      zsa.enable = true;
      android.enable = true;
    };
    vars = {
      role = "desktop";
      tailscaleIP = "100.79.120.120";
      desktopEnvironments = [ "gnome" ];
    };
  };

  sops.secrets = {
    "network-manager.env" = { };
    evilwoods-nix-key = {
      sopsFile = builtins.toString (inputs.evilsecrets + "/secrets/nix-key.yaml");
      owner = "root";
      group = "root";
      mode = "0400";
    };
  };

  nix = {
    settings = {
      max-jobs = "auto";
      auto-optimise-store = true;
      secret-key-files = [
        "${config.sops.secrets."evilwoods-nix-key".path}"
      ];
    };
  };

  nixpkgs.overlays = [
    (import ../../overlays/pythonPackages.nix)
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {
      verbose = false;
      systemd.enable = true;
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 100;
      };
    };

    tmp.useTmpfs = true;
  };

  system = {
    rebuild.enableNg = true;

    stateVersion = "25.11";
  };

  fileSystems = {
    "/mnt/nfs/aitvaras_share" = {
      device = "100.75.110.79:/mnt/storage/shares/aitvaras";
      fsType = "nfs";
    };
    "/mnt/nfs/video" = {
      device = "100.75.110.79:/mnt/storage/media/video";
      fsType = "nfs";
    };
  };

  networking = {
    nftables.enable = true;

    wireless.iwd.enable = true;

    networkmanager = {
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
  };

  # system.etc.overlay.enable = true;
  services = {
    userborn.enable = true;

  };

  programs = {
    steam.enable = true;

    command-not-found.enable = false;

    nix-ld = {
      enable = true;
    };
  };

  systemd.services.nix-deamon = {
    environment.TMPDIR = "/var/tmp";
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

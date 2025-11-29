{
  inputs,
  config,
  pkgs,
  ...
}:
let
  secretsPath = builtins.toString inputs.evilsecrets;
in
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
      tailscaleIP = "100.68.20.3";
      desktopEnvironments = [ "gnome" ];
    };
  };

  sops.secrets = {
    "network-manager.env" = { };
    "network-manager-b629.env" = {
      sopsFile = secretsPath + "/secrets/aitvaras/default.yaml";
      owner = "root";
      group = "root";
      mode = "0400";
    };
    evilwoods-nix-key = {
      sopsFile = secretsPath + "/secrets/aitvaras/nix-key.yaml";
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

  # nixpkgs.overlays = [
  #   (import ../../overlays/pythonPackages.nix)
  # ];

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
    # nixos-init.enable = true;
    # etc.overlay.enable = true;

    stateVersion = "25.11";
  };

  networking = {
    nftables.enable = true;

    wireless.iwd.enable = true;

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
      ensureProfiles = {
        environmentFiles = [
          config.sops.secrets."network-manager.env".path
          config.sops.secrets."network-manager-b629.env".path
        ];
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
          b629-5G = {
            connection = {
              id = "629-5GHz";
              type = "wifi";
              interface-name = "wlan0";
              autoconnect = true;
            };
            wifi = {
              mode = "infrastructure";
              ssid = "629-5GHz";
            };
            wifi-security = {
              auth-alg = "open";
              key-mgmt = "wpa-psk";
              psk = "$b629_psk";
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
    firewalld.enable = true;
    userborn.enable = true;

    rpcbind.enable = true;
  };

  programs = {
    steam.enable = true;

    command-not-found.enable = false;

    nix-ld = {
      enable = true;
    };
  };

  systemd = {
    services.nix-daemon = {
      environment.TMPDIR = "/var/tmp";
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

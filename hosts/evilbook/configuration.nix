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
      gnome.enable = true;
      hyprland.enable = false;
      zsa.enable = true;
    };
    vars = {
      tailscaleIP = "100.79.120.120";
    };
  };

  sops.secrets = {
    "network-manager.env" = { };
  };

  nix = {
    settings = {
      max-jobs = "auto";
      auto-optimise-store = true;
    };
  };

  nixpkgs.overlays = [
    (import ../../overlays/packages.nix)
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

    stateVersion = "24.11";
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

    xserver.xkb = {
      layout = "us,us,se";
      variant = "colemak_dh_iso,,";
      options = "grp:alt_shift_toggle";
    };
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

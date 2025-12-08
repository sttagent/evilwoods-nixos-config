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
    flags = {
      role = "desktop";
      tailscaleIP = "100.68.20.3";
      desktopEnvironments = [ "gnome" ];
    };
  };

  sops.secrets = {
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

  # system.etc.overlay.enable = true;
  services = {
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

    settings.Manager = {
      DefaultTimeoutStopSec = "45s";
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

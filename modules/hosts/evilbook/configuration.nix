{
  inputs,
  ...
}:
{
  flake.modules.nixos.hostEvilbook =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.evilwoods.variables) mainUser;
      secretsPath = toString inputs.evilsecrets;
    in
    {
      # host specific variables
      sops.secrets = {
        evilwoods-nix-key = {
          sopsFile = secretsPath + "/secrets/nix-key.yaml";
          owner = "root";
          group = "root";
          mode = "0400";
        };
        niks3-api-token = {
          sopsFile = secretsPath + "/secrets/evilcloud/cloudflare-r2.yaml";
          owner = mainUser;
          group = "users";
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
      systemd = {
        services.nix-daemon = {
          environment.TMPDIR = "/var/tmp";
        };

        settings.Manager = {
          DefaultTimeoutStopSec = "45s";
        };
      };

      programs.nh = {
        flake = "/home/${mainUser}/Source/private/evilwoods-nixos-config";
      };

      environment.variables = {
        NIKS3_AUTH_TOKEN_FILE = "${config.sops.secrets."niks3-api-token".path}";
        NIKS3_SERVER_URL = "https://cache.evilwoods.net";
      };

      # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
    };
}

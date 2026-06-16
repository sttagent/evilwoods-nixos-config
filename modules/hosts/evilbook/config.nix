{ inputs, den, ... }: {
  den.aspects.evilbook =
    { host }:
    {
      includes = with den.aspects; [
        desktop.cosmic
        gaming.steam
        hardware.zsa
        virtualisation.podman
      ];
      nixos =
        { config, pkgs, ... }:
        let

          secretsPath = toString inputs.evilsecrets;
        in
        {
          system.stateVersion = host.stateVersion;

          sops.secrets = {
            evilwoods-nix-key = {
              sopsFile = secretsPath + "/secrets/nix-key.yaml";
              owner = "root";
              group = "root";
              mode = "0400";
            };
            niks3-api-token = {
              sopsFile = secretsPath + "/secrets/evilcloud/cloudflare-r2.yaml";
              owner = host.mainUser;
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
            flake = "/home/${host.mainUser}/Source/private/evilwoods-nixos-config";
          };

          environment.variables = {
            NIKS3_AUTH_TOKEN_FILE = "${config.sops.secrets."niks3-api-token".path}";
            NIKS3_SERVER_URL = "https://cache.evilwoods.net";
          };
        };

      provides.to-users.homeManager =
        { pkgs, ... }:
        {
          home.stateVersion = host.stateVersion;
          home.packages = [ pkgs.vim ];
        };
    };
}

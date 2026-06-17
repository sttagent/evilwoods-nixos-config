{
  den.aspects.rynepc = {
    provides.to-users.homeManager = { host, user, ... }: {
      home.stateVersion = host.stateVersion;
    };
    nixos =
      {
        host,
        pkgs,
        ...
      }:
      {
        # host specific variables
        nix = {
          settings = {
            max-jobs = "auto";
            auto-optimise-store = true;
            allowed-users = [ "${host.mainUser}" ];
          };
        };

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

        services = {
          displayManager.gdm.autoSuspend = false;
          xserver.xkb.layout = "us,se";
        };

        systemd = {
          services.nix-daemon = {
            environment.TMPDIR = "/var/tmp";
          };
        };

        system.stateVersion = host.stateVersion;

        users.users.root.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
        ];
      };
  };
}

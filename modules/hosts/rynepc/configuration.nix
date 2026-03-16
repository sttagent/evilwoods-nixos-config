{
  inputs,
  ...
}:
{
  flake.modules.nixos.hostRynepc =
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (config.evilwoods.variables) mainUser;
    in
    {
      # host specific variables
      evilwoods = {
        variables = {
          mainUser = "ryne";
        };
      };

      nix = {
        settings = {
          max-jobs = "auto";
          auto-optimise-store = true;
          allowed-users = [ "${mainUser}" ];
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

      system.stateVersion = "25.11";

      users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
      ];
    };
}

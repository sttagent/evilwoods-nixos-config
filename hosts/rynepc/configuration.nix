{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.evilwoods.base) mainUser;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    # (modulesPath + "/profiles/perlless.nix")
  ];

  evilwoods = {
    steam.enabled = true;
    desktop.desktopEnvironment = "gnome";
    base = {
      role = "desktop";
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
    userborn.enable = true;

    rpcbind.enable = true;

    displayManager.gdm.autoSuspend = false;
    xserver.xkb.layout = "us,se";
  };

  programs = {
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

  system.stateVersion = "25.11";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGFc8oFtu7i4WBlbcDMB7ua9cHJW2bzeomrLFddokw7v aitvaras@evilbook"
  ];
}

{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.evilwoods.vars) mainUser;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
    # (modulesPath + "/profiles/perlless.nix")
  ];

  evilwoods = {
    vars = {
      role = "desktop";
      desktopEnvironments = [ "gnome" ];
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

  system.stateVersion = "25.11";
}

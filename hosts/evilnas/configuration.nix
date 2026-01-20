{
  inputs,
  ...
}:
{
  imports = [
    inputs.sobs-nix-25-11.nixosModules.sops
    inputs.home-manager-25-11.nixosModules.home-manager
  ];

  system.stateVersion = "25.11";

  evilwoods = {
    base = {
      role = "server";
    };
    vmGuest.enabled = true;
    podman.enabled = true;
  };

  networking = {
    nftables.enable = true;
    useDHCP = true;
  };

  services.openssh = {
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 100;
      };
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

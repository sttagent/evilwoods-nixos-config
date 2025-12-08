{
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix-stable.nixosModules.sops
    inputs.home-manager-stable.nixosModules.home-manager
  ];

  system.stateVersion = "25.11";

  evilwoods = {
    flags = {
      role = "server";
    };
    config = {
      vmGuest.enable = true;
      podman.enable = true;
    };
  };

  networking = {
    nftables.enable = true;
    useDHCP = true;
  };

  virtualisation = {
    oci-containers = {
      backend = "podman";
    };
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

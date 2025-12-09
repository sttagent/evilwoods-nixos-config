{
  inputs,
  ...
}:
{
  imports = [
    inputs.sops-nix-stable.nixosModules.sops
    inputs.home-manager-stable.nixosModules.home-manager
  ];

  evilwoods = {
    flags = {
      role = "server";
    };
    config = {
      vmGuest.enabled = true;
      podman.enable = true;
    };
  };

  system.stateVersion = "25.05";

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

  systemd.tmpfiles.rules = [ "d /var/storage/data 755 root root" ];

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

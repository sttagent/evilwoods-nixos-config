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
    vmGuest.enabled = true;
    podman.enabled = true;
    flags = {
      role = "server";
    };
  };

  system.stateVersion = "25.05";

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

  systemd.tmpfiles.rules = [ "d /var/storage/data 755 root root" ];

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

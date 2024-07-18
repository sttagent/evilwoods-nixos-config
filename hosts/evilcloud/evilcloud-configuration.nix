{ config, lib, pkgs, ... }:
{

  boot = {
    initrd = {
      verbose = false;
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
    };
  };

  programs.nix-ld = {
    enable = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

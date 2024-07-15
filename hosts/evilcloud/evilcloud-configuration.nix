{ config, lib, pkgs, thisHost, ... }:
{
  networking.hostName = "${thisHost.hostname}";

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

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = "24.05"; # Did you read the comment?
}

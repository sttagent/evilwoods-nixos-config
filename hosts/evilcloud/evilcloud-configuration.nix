{ config, lib, pkgs, thisHost, ... }:
{
  evilwoods.podman = true;
  # evilwoods.docker = true;
  # evilwoods.libvirtd = true;

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

  fileSystems = {
    "/srv/external-backup" = {
      device = "/dev/disk/by-label/External-backup";
      fsType = "btrfs";
      options = [ "defaults" "compress=zstd" ];
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = "24.05"; # Did you read the comment?
}

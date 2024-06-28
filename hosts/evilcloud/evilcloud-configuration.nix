{ config, lib, pkgs, thisHost, ... }:
{
  evilwoods.podman = true;
  # evilwoods.docker = true;
  # evilwoods.libvirtd = true;

  networking.hostName = thisHost.hostname;

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

  fileSystems."/home/aitvaras/Storage" = {
    device = "/dev/disk/by-partlabel/disk-data-home";
    fsType = "btrfs";
    options = [ "subvol=storage" "compress=1" ];
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  # Use the systemd-boot EFI boot loader.

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = "24.05"; # Did you read the comment?
}

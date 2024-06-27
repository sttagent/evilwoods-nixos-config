{ config, lib, pkgs, thisHost, ... }:
{
  evilwoods.podman = true;
  evilwoods.docker = true;
  evilwoods.libvirtd = true;

  networking.hostName = thisHost;

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      verbose = false;
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
    };

    kernelModules = [ "kvm-intel" ];
    #kernelPackages = pkgs.linuxPackages_6_1; # nvidia incopatible with linuxPackages_latest
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

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  # Use the systemd-boot EFI boot loader.

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = "24.05"; # Did you read the comment?
}

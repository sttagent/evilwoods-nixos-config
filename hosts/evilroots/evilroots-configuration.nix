{ config, lib, pkgs, ... }:
let
  mainUser = config.evilcfg.mainUser;
in
{
  evilcfg.ssh = true;
  evilcfg.enableGnome = true;
  evilcfg.nvidia = true;
  #evilcfg.steam = true;
  evilcfg.zsa = true;
  evilcfg.podman = true;
  evilcfg.docker = true;
  evilcfg.libvirtd = true;
  evilcfg.enableHyprland = true;

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

  fileSystems."/home/${mainUser}/Storage" = {
    device = "/dev/disk/by-partlabel/disk-data-home";
    fsType = "btrfs";
    options = [ "subvol=storage" "nocompress" "noatime" "nodatacow" ];
  };

  # LTU VPN
  services.strongswan.enable = true;
  networking.networkmanager.enableStrongSwan = true;


  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  # Use the systemd-boot EFI boot loader.

  # sops.defaultSopsFile = ../../secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";
  # sops.secrets.example-key = { };
  # sops.secrets."myservice/my_subdir/my_secret" = { };
  # sops.age.keyFile = /home/${mainUser}/.config/sops/age/keys.txt;
  # sops.gnupg.sshKeyPaths = [ ];

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = "24.05"; # Did you read the comment?
}

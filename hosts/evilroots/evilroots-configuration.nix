{ config, lib, pkgs, ... }:
let
  mainUser = config.evilcfg.mainUser;
in
{
  evilcfg.ssh = true;
  evilcfg.desktop = true;
  evilcfg.nvidia = true;
  #evilcfg.steam = true;
  evilcfg.zsa = true;
  evilcfg.podman = true;
  evilcfg.docker = true;
  evilcfg.libvirtd = true;

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

  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    verbose = false;
  };
  boot.kernelModules = [ "kvm-intel" ];

  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxPackages_6_1; # nvidia incopatible with linuxPackages_latest
    #consoleLogLevel = 0;
    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "splash"
      #"rd.systemd.show_status=false"
    ];
  };

  # sops.defaultSopsFile = ../../secrets/secrets.yaml;
  # sops.defaultSopsFormat = "yaml";
  # sops.secrets.example-key = { };
  # sops.secrets."myservice/my_subdir/my_secret" = { };
  # sops.age.keyFile = /home/${mainUser}/.config/sops/age/keys.txt;
  # sops.gnupg.sshKeyPaths = [ ];

  # Garbage collection
  boot.loader.systemd-boot.configurationLimit = 100;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = "24.05"; # Did you read the comment?
}

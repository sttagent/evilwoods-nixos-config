({ config, lib, pkgs, ... }:
let
  primaryUser = config.evilcfg.primaryUser;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${primaryUser} = import ./home.nix;
  };

  networking.hostName = "evilroots";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config.allowUnfree = true;

  evilcfg.ssh = true;
  evilcfg.desktop = true;
  evilcfg.nvidia = true;
  #evilcfg.steam = true;
  evilcfg.zsa = true;
  evilcfg.podman = true;

  # LTU VPN
  services.strongswan.enable = true;
  networking.networkmanager.enableStrongSwan = true;

  # docker setup
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };

    storageDriver = "btrfs";
  };

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

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.secrets.example-key = { };
  sops.secrets."myservice/my_subdir/my_secret" = { };
  sops.age.keyFile = /home/${primaryUser}/.config/sops/age/keys.txt;
  sops.gnupg.sshKeyPaths = [ ];

  # Version of NixOS installed from live disk. Needed for backwards compatability.
  system.stateVersion = "24.05"; # Did you read the comment?
})

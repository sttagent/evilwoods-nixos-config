{
  description = "Evilwoods nixos config";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, ... } @ inputs: 
  let
    evilLib = import ./lib;
  in {
    nixosConfigurations = {
      evilroots = let nixpkgs = nixpkgs-unstable; in nixpkgs.lib.nixosSystem {
        system = evilLib.defaultSystem;

        modules = [
          ./modules

          ({lib, pkgs, ...}: {
            networking.hostName = "evilroots";

            nix.extraOptions = ''
              experimental-features = nix-command flakes
            '';

            nixpkgs.config.allowUnfree = true;

            evilcfg.ssh = true;
            evilcfg.desktop = true;
            evilcfg.nvidia = true;
            #evilcfg.steam = true;
            evilcfg.zsa = true;
            evilcfg.podman = true;

            boot.initrd = {
              availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
              verbose = false;
            };
            boot.kernelModules = [ "kvm-intel" ];

            networking.useDHCP = nixpkgs.lib.mkDefault true;
            # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;

            hardware.cpu.intel.updateMicrocode = nixpkgs.lib.mkDefault true;
            hardware.enableRedistributableFirmware = nixpkgs.lib.mkDefault true;
            # Use the systemd-boot EFI boot loader.
            boot = {
              loader = {
                efi = {
                  canTouchEfiVariables = true;
                  efiSysMountPoint = "/boot/efi";
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

            # Disk formating
            fileSystems."/" = {
              device = "/dev/disk/by-label/NIXOS";
              fsType = "btrfs";
              options = [ "subvol=root" "compress=zstd" ];
            };
        
            fileSystems."/home" = {
              device = "/dev/disk/by-label/NIXOS";
              fsType = "btrfs";
              options = [ "subvol=home" "compress=zstd" ];
            };

            fileSystems."/nix" = {
              device = "/dev/disk/by-label/NIXOS";
              fsType = "btrfs";
              options = [ "subvol=nix" "compress=zstd" "noatime" ];
            };

            fileSystems."/boot" = {
              device = "/dev/disk/by-label/BOOT";
              fsType = "ext4";
            };

            fileSystems."/boot/efi" = {
              device = "/dev/disk/by-label/EFI";
              fsType = "vfat";
            };

            fileSystems."/home/aitvaras/localdata" = {
              device = "/dev/disk/by-label/fedora_fedora";
              fsType = "btrfs";
              options = [ "subvol=data" "compress=zstd" "noatime" ];
            };

            # Version of NixOS installed from live disk. Needed for backwards compatability.
            system.stateVersion = "22.05"; # Did you read the comment?
          })
        ];
      };
    };
  };
}

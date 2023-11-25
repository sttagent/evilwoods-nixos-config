{
  description = "Evilwoods nixos config";

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko = {
        url = "github:nix-community/disko";
	inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, disko, home-manager, ... } @ inputs: 
  let
    evilLib = import ./lib;
  in {
    nixosConfigurations = {
      evilroots = let nixpkgs = nixpkgs-unstable; in nixpkgs.lib.nixosSystem {
        system = evilLib.defaultSystem;

        modules = [
          disko.nixosModules.disko
          ./evilroots-partition-scheme.nix
          {
            _module.args.disks = [ "/dev/sdb" ];
          }

          ./modules

          ({lib, pkgs, ...}: {
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

            # Version of NixOS installed from live disk. Needed for backwards compatability.
            system.stateVersion = "23.05"; # Did you read the comment?
          })

	  home-manager.nixosModules.home-manager
	  {
	    home-manager = {
	      useGlobalPkgs = true;
	      useUserPackages = true;
	      users.aitvaras = import ./home.nix;
	    };
	  }
        ];
      };
    };
  };
}

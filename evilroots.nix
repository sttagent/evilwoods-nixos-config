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
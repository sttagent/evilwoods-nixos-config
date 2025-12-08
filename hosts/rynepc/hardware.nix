{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
  inherit (config.evilwoods.vars) isTestEnv;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  config = mkMerge [
    (mkIf (!isTestEnv) {
      boot = {
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "ahci"
            "usbhid"
            "ums_realtek"
            "usb_storage"
            "sd_mod"
            "sr_mod"
          ];
          kernelModules = [ ];
        };

        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
        blacklistedKernelModules = [ "nouveau" ];
      };

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            nvidia-vaapi-driver
            libva-vdpau-driver
            libvdpau-va-gl
          ];
        };
        nvidia = {
          open = false; # see the note above
        };
        cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
      services.xserver.videoDrivers = [
        "nvidia"
      ];
    })
  ];
}

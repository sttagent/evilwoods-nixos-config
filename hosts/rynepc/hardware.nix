{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
  vmGuestEnvNotEnabled = !config.evilwoods.vmGuest.enabled;
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  config = mkMerge [
    (mkIf vmGuestEnvNotEnabled {
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

      environment = {
        systemPackages = [ pkgs.libva-utils ];
        variables = {
          MOZ_DISABLE_RDD_SANDBOX = "1";
          NVD_BACKEND = "direct";
          LIBVA_DRIVER_NAME = "nvidia";
        };
      };

      programs.firefox.preferences = {
        "media.ffmpeg.vaapi.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;
        "gfx.x11-egl.force-enabled" = true;
        "widget.dmabuf.force-enabled" = true;
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

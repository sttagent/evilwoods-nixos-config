{ config, pkgs, lib, ... }:

with lib;

let
  desktop = config.evilcfg.desktop;
  mainUser = config.evilcfg.mainUser;
in
{
  options.evilcfg = {
    # If machine will have a desktop or not
    desktop = mkEnableOption "Gnome Deskop";
  };


  config = mkIf desktop {
    fonts.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "SourceCodePro"
          "JetBrainsMono"
          "Hack"
        ];
      })
    ];

    boot = {
      kernelParams = [
        "quiet"
        "splash"
      ];
      plymouth.enable = true;
    };

    environment.variables = {
      NIXOS_OZONE_WL = "1";
    };

    zramSwap.enable = true;

    # Recommended for pipwire
    security.rtkit.enable = true;
    security.pam.services.${mainUser}.enableGnomeKeyring = true;

    # Needs to be disabled if using pipwire
    hardware.pulseaudio.enable = false;

    programs = {
      xwayland.enable = true;
      gnupg.agent = {
        enable = true;
         enableSSHSupport = true;
      };
    };

    services = {
      flatpak.enable = true;
      fstrim.enable = true;
      pcscd.enable = true;
      # Enable the X11 windowing system.
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      udev = {
        packages = [ pkgs.yubikey-personalization ];
        extraRules = ''
          # Bitbox udev rules
          SUBSYSTEM=="usb", SYMLINK+="bitbox02_%n", GROUP="plugdev", MODE="0664", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403"
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", SYMLINK+="bitbox02_%n", GROUP="plugdev", MODE="0664", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403"
          SUBSYSTEM=="usb", SYMLINK+="dbb%n", GROUP="plugdev", MODE="0664", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402"
          KERNEL=="hidraw*", SUBSYSTEM=="hidraw", SYMLINK+="dbbf%n", GROUP="plugdev", MODE="0664", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402"
        '';
      };
    };
  };
}

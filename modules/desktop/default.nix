{ config, pkgs, lib, ... }:

with lib;

let
  desktop = config.evilcfg.desktop;
in
{
  imports = [
    ./packages.nix
    ./moonlander.nix
    ./steam.nix
  ];

  options.evilcfg = {
    # If machine will have a desktop or not
    desktop = mkEnableOption "Gnome Deskop";
  };


  config = mkIf desktop {
    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      # gnomeExtensions.valent
    ];

    zramSwap.enable = true;

    # Recommended for pipwire
    security.rtkit.enable = true;
    security.pam.services.aitvaras.enableGnomeKeyring = true;

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
      fstrim.enable = true;
      pcscd.enable = true;
      # Enable the X11 windowing system.
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
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
          # Allow users to use the AVR avrisp2 programmer
          SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="2104", TAG+="uaccess", RUN{builtin}+="uaccess"
        '';
      };

      flatpak.enable = true;
    };
  };
}

{config, pkgs, lib, ...}:

with lib;

let
  desktop = config.evilcfg.desktop; 
in {
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
  
    services.fstrim.enable = true;

    zramSwap.enable = true;

    # Recommended for pipwire
    security.rtkit.enable = true;
    
    security.pam.services.aitvaras.enableGnomeKeyring = true;

    # Needs to be disabled if using pipwire
    hardware.pulseaudio.enable = false;

    programs.xwayland.enable = true;
    
    services = {

      # Enable the X11 windowing system.
      xserver = {

        enable = true;

        videoDrivers = [ "nvidia" ];
  
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

      udev.packages = [ pkgs.yubikey-personalization ];

      flatpak.enable = true;

    };
  };
}

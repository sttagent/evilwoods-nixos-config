{config, pkgs, lib, ...}:

with lib;

let
  cfg = config.sys.desktop; 
in {
  imports = [
    ./packages.nix
    ./moonlander.nix
  ];

  options.sys.desktop = {
    enable = mkEnableOption "Deskop";
  };


  config = mkIf cfg.enable {
    services.fstrim.enable = true;

    # Recommended for pipwire
    security.rtkit.enable = true;
    # Needs to be disabled if using pipwire
    hardware.pulseaudio.enable = false;
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

      flatpak.enable = true;

    };
  };
}

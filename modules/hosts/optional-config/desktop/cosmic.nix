{ den, ... }:
{
  den.aspects.desktop.cosmic = {
    includes = [ den.aspects.desktop ];
    nixos = {
      services = {
        gnome.gnome-keyring.enable = false;
        oo7.enable = true;
        displayManager.cosmic-greeter.enable = true;
        desktopManager.cosmic.enable = true;
      };
    };
  };
}

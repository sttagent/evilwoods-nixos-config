{ den, ... }:
{
  den.aspects.desktop-environment.cosmic = {
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

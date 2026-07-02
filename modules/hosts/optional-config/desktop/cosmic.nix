{ den, ... }:
{
  den.aspects.desktop.cosmic = {
    includes = [ den.aspects.desktop ];
    nixos = {
      services = {
        displayManager.cosmic-greeter.enable = true;
        desktopManager.cosmic.enable = true;
      };
    };
  };
}

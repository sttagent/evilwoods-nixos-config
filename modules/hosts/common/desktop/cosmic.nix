{ self, ... }:
{
  flake.modules.nixos.cosmic = {
    imports = [ self.modules.nixos.desktop ];
    services = {
      displayManager.cosmic-greeter.enable = true;
      desktopManager.cosmic.enable = true;
    };
  };
}

{ self, ... }:
{
  flake.modules.nixos.gnome =
    {
      pkgs,
      ...
    }:
    {
      imports = [ self.modules.nixos.desktop ];

      evilwoods.variables.desktopEnvironment = "gnome";

      services = {
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };

      environment.systemPackages = with pkgs; [
        dconf-editor
        papers
        showtime
        gnome-extension-manager
        gsettings-desktop-schemas
        dconf
        valent # does not build on nixos-unstable
        pika-backup
        endeavour

        gnomeExtensions.appindicator
        gnomeExtensions.valent
        gnomeExtensions.battery-health-charging
        gnomeExtensions.blur-my-shell

      ];

      environment.gnome.excludePackages = with pkgs; [
        epiphany
        geary
        evince
        totem
        gnome-software
        gnome-tour
      ];

      programs = {
        dconf.enable = true;
        # evolution.enable = true;
      };
    };
}

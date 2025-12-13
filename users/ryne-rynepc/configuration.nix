currentUser:
{
  pkgs,
  ...
}:
{
  imports = [ ../${currentUser} ];
  users.users.${currentUser}.uid = 1001;

  home-manager.users.${currentUser} = {

    programs = {
      home-manager.enable = true;

      ghostty = {
        enable = true;
        settings = {
          font-family = "CommitMono Nerd Font Mono";
          theme = "Miasma";
          window-theme = "ghostty";
          window-padding-x = 2;
          adw-toolbar-style = "flat";
          shell-integration = "fish";
          command = "fish";
        };
      };

    };
    xdg = {
      autostart = {
        enable = true;
        entries = [
          "${pkgs.filen-desktop}/share/applications/filen-desktop.desktop"
        ];
      };
      configFile = {
      };
    };
  };
}

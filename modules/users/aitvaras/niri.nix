{ inputs, den, ... }:
{
  den.aspects.aitvaras.niri = {
    homeManager =
      let
        niri-config = inputs.self.outPath + "/dotfiles/niri/config.kdl";
        niri-window-rules = inputs.self.outPath + "/dotfiles/niri/window-rules.kdl";
        niri-keybinds = inputs.self.outPath + "/dotfiles/niri/keybinds.kdl";
      in
      {
        dconf.settings = {
          "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = "Adwaita-dark";
            accent-color = "green";
          };
        };

        xdg.configFile = {
          "niri/config.kdl" = {
            text = ''
              include  "${niri-config}"
              include  "${niri-window-rules}"
              include  "${niri-keybinds}"

              include optional=true "noctalia.kdl"
              include optional=true "overrides.kdl"
            '';
          };
        };
      };
    kanshi-command-list = {
      laptop-only = [
        "niri msg action switch-layout 0"
      ];
      external-monitor = [
        "niri msg action switch-layout 1"
      ];
    };
  };

  den.aspects.aitvaras = {
    includes = [
      (den.lib.aspects.fx.includes.includeIf
        ({ host, ... }: host.hasAspect den.aspects.roles.desktop.niri)
        [
          den.aspects.aitvaras.niri
        ]
      )
    ];
  };
}

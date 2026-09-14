{ inputs, den, ... }:
{
  den.aspects.aitvaras.umbriel = { host }: {
    homeManager =
      {
        lib,
        pkgs,
        ...
      }:
      let
        umbriel-exec = lib.getExe pkgs.umbriel;
        umbriel-defaults = inputs.self.outPath + "/dotfiles/umbriel/defaults.toml";
        umbriel-config = inputs.self.outPath + "/dotfiles/umbriel/config.toml";
        umbriel-keybinds = inputs.self.outPath + "/dotfiles/umbriel/keybinds.toml";
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
          "umbriel/config.toml" = {
            text = ''
              [include]
                files = [
                  "${umbriel-defaults}",
                  "${umbriel-config}",
                  "${umbriel-keybinds}"
                ]
              [include.optional]
                files = [
                  "~/.config/umbriel/noctalia.toml",
                  "~/.config/umbriel/overrides.toml"
                ]
            '';
          };
        };
      };
  };

  den.aspects.aitvaras = {
    includes = [
      (den.lib.aspects.fx.includes.includeIf
        ({ host, ... }: host.hasAspect den.aspects.roles.desktop.umbriel)
        [
          den.aspects.aitvaras.umbriel
        ]
      )
    ];
  };
}

{ inputs, den, ... }:
{
  den.aspects.aitvaras.noctalia = {
    homeManager =
      let
        noctaliaConfigPath = inputs.self.outPath + "/dotfiles/noctalia/config.toml";
      in
      {
        xdg = {
          configFile = {
            "noctalia/config.toml" = {
              source = noctaliaConfigPath;
            };
          };
        };
      };
    kanshi-command-list = {
      laptop-only = [
        "noctalia msg bar-show default eDP-1"
      ];
      external-monitor = [
        "noctalia msg bar-hide default eDP-1"
      ];
    };
  };

  den.aspects.aitvaras = {
    includes = [
      (den.lib.aspects.fx.includes.includeIf
        ({ host, ... }: host.hasAspect den.aspects.roles.desktop.noctalia)
        [
          den.aspects.aitvaras.noctalia
        ]
      )
    ];
  };
}

{ inputs, ... }:
{
  den.aspects.aitvaras.niri.homeManager =
    let
      noctaliaConfigPath = inputs.self.outPath + "/dotfiles/noctalia/noctalia-config.toml";
    in
    {
      xdg = {
        configFile = {
          "noctalia/noctalia-config.toml" = {
            source = noctaliaConfigPath;
          };
        };
      };
    };
}

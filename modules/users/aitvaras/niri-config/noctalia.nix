{ inputs, ... }:
{
  den.aspects.aitvaras.niri.homeManager =
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
}

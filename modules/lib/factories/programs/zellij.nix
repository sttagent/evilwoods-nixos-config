{ lib, ... }:
{
  config.flake.lib.factory.program.zellij =
    {
      shell,
      extraConfig ? { },
    }:
    {
      zellij = lib.merge [
        {
          enable = false;
          settings = {
            default_mode = "locked";
            default_shell = shell;
            mirror_session = true;
            theme = "gruvbox-dark";
            attach_to_session = true;
          };
        }
        extraConfig
      ];
    };
}

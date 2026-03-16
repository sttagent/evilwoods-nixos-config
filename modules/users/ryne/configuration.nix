{
  self,
  ...
}:
{
  flake.modules.nixos.userRyne =
    { pkgs, ... }:
    {
      imports = [
        (self.lib.factory.user {
          userName = "ryne";
          desc = "Ryne Ramanauskas";
          extraConfig = {
            shell = pkgs.fish;
          };
        })
      ];
    };
}

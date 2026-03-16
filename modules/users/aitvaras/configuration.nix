{
  self,
  ...
}:
{
  flake.modules.nixos.userAitvaras =
    { pkgs, ... }:
    {
      imports = [
        (self.lib.factory.user {
          userName = "aitvaras";
          desc = "Arvydas Ramanauskas";
          isAdmin = true;
          extraConfig = {
            shell = pkgs.fish;
          };
        })
      ];
    };
}

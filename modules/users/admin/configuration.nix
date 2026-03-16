{
  self,
  ...
}:
{
  flake.modules.nixos.userAdmin =
    { pkgs, ... }:
    {
      imports = [
        (self.lib.factory.user {
          userName = "admin";
          desc = "Administrator";
          isAdmin = true;
          extraConfig = {
            shell = pkgs.fish;
          };
        })
      ];
    };
}

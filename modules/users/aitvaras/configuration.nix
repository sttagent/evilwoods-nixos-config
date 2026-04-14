{
  self,
  ...
}:
{
  flake.modules.nixos.userAitvaras = {
    imports = [
      (self.lib.factory.user {
        userName = "aitvaras";
        desc = "Arvydas Ramanauskas";
        isAdmin = true;
      })
    ];
  };
}

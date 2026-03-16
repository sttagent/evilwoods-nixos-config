{
  flake.modules.nixos.userRyne =
    { config, ... }:
    let
      currentUser = "ryne";
    in
    {
      home-manager = {
        users.${currentUser} = {
          programs = {
          };
        };
      };
    };
}

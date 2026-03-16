{ lib, ... }:
{
  flake.modules.nixos.userAitvaras =
    { lib, ... }:
    let
      inherit (lib) mkOption types;
      currentUser = "aitvaras";
    in
    {
      options.evilwoods.${currentUser}.shell = mkOption {
        type = types.str;
        default = "fish";
      };
    };
}

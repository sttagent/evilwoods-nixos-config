{ lib, ... }:
{
  den.schema.host.options =
    let
      inherit (lib) mkOption;
    in
    {
      mainUser = mkOption { default = "aitvaras"; };
      desktopEnvironment = mkOption { default = "cosmic"; };
      stateVersion = mkOption { default = "26.11"; };
    };
}

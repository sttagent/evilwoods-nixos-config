{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    test = mkOption {
      type = types.str;
      default = "";
    };
  };
  config = {
    test = "";
  };
}

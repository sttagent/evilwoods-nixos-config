{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.evilwoods.testEnv;
in
{
  options.evilwoods.testEnv.enabled = mkEnableOption "test environment";
  config = mkIf cfg.enabled {
  };

}

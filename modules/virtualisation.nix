{ config, lib, ... }:

with lib;
let
  cfg = config.evilcfg;
in
{
  options.evilcfg.podman = mkEnableOption "podman";

  config = mkIf cfg.podman {
    virtualisation = {
      podman = {
        enable = true;
        enableNvidia = mkIf cfg.nvidia true;
      };
    };
  };
}

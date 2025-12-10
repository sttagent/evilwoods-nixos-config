{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.evilwoods.podman;
in
{
  options = {
    evilwoods = {
      podman.enabled = mkEnableOption "podman";
    };
  };

  config = mkIf cfg.enabled {
    virtualisation = {
      podman = {
        enable = true;
        autoPrune.enable = true;
      };
      oci-containers.backend = "podman";
    };
  };
}

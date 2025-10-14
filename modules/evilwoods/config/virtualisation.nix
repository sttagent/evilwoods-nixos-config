{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.evilwoods.config.podman;
in
{
  options = {
    evilwoods.config = {
      podman.enable = mkEnableOption "Enable podman";
    };
  };

  config = mkIf cfg.enable {
    virtualisation = {
      podman = {
        enable = true;
        autoPrune.enable = true;
      };
      oci-containers.backend = "podman";
    };
  };
}

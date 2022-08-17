{config, lib, ...}:

with lib;
let
  podman = config.evilcfg.podman;
  nvidia = config.evilcfg.nvidia;
in {
  options.evilcfg.podman = mkEnableOption "podman";

  config = {
    virtualisation = {
      podman = mkIf config.evilcfg.podman {
        enable = true;
        enableNvidia = mkIf nvidia true;
      };
    };
  };
}

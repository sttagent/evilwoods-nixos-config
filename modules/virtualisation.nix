{config, lib, ...}:

with lib;
let
  podman = config.evilcfg.podman;
  nvidia = config.evilcfg.nvidia;
in {
  options.evilcfg.podman = mkEnableOption "podman";

  config = (
    podman = mkIf podamn {
      enable = true;
      enableNvidea = mkIf nvidia true;
    };
  );
}

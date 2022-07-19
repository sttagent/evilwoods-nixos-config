{config, pkgs, lib, ...}:

with lib;

let
  cfg = config.sys.desktop; 
in {
  imports = [
    ./packages.nix
    ./moonlander.nix
  ];

  options.sys.desktop = {
    enable = mkEnableOption "Deskop";
  };


  config = mkIf cfg.enble {
  };
}

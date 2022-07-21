{ config, pkgs, lib, ...}:

with lib;

let
  cfg = config.sys;
in {
  imports = [
    ./core-packages.nix
  ];

  options.sys.ssh = {
    enable = mkEnableOption "testopenSSH";
  };
  
  config = {
    services.openssh = mkIf cfg.ssh.enable {
      enable = true;
    };


    # Recommended by wiki for tailscale
    networking.firewall.checkReversePath = "loose";
    services.tailscale.enable = true;


    # Set your time zone.
    time.timeZone = "Europe/Stockholm";
  };
}

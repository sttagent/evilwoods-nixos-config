{ config, pkgs, lib, ...}:

with lib;

let
  cfg = config.sys;
in {
  imports = [
    ./core-packages.nix
  ];

  options.sys.ssh = {
    enable = mkEnableOption "openSSH";
  };
  
  config = {
    services.openssh = mkIf cfg.ssh.enable {
      enable = true;
    };

    # Set your time zone.
    time.timeZone = "Europe/Stockholm";
  };
}

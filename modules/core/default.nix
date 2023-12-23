{ config, pkgs, lib, ... }:

with lib;

let
  ssh = config.evilcfg.ssh;
  primaryUser = config.evilcfg.primaryUser;
in
{
  imports = [
    ./users
  ];

  options.evilcfg.ssh = mkEnableOption "ssh";

  config = {
    services = {
      openssh = mkIf ssh {
        enable = true;
      };
    };
  };
}

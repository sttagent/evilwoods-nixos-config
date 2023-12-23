{ config, pkgs, lib, ... }:

with lib;

let
  ssh = config.evilcfg.ssh;
  mainUser = config.evilcfg.mainUser;
in
{
  imports = [
    ./shared-packages.nix
    ./shared-configuration.nix
    ./main-user.nix
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

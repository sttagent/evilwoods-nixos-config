{ lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  den.aspects.hostBase = {
    nixos = {
      networking = {
        useDHCP = mkDefault true;
        firewall = {
          enable = mkDefault true;
        };
        enableIPv6 = mkDefault false;
        nftables.enable = mkDefault true;
      };

      services = {
        firewalld.enable = true;
        openssh = {
          enable = mkDefault true;
          settings = {
            PasswordAuthentication = mkDefault false;
          };
        };
      };
    };
  };
}

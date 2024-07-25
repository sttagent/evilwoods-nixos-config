{ config, lib, pkgs, ... }:
{

  boot = {
    initrd = {
      verbose = false;
    };
  };

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

{ config, lib, pkgs, ... }:
{

  boot = {
    initrd = {
      verbose = false;
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

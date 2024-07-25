{ config, lib, pkgs, ... }:
{

  boot = {
    initrd = {
      verbose = false;
    };

    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };

  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

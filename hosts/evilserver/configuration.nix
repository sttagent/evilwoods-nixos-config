{ config, lib, pkgs, ... }:
{
  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  programs.nix-ld = {
    enable = true;
  };

  virtualisation.oci-containers = {
    backend = "podman";
  };

  fileSystems = {
    "/var/backups" = {
      device = "/dev/disk/by-label/External-backup";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" ];
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

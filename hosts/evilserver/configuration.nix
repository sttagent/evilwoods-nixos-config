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

  virtualisation = {
    oci-containers = {
      backend = "docker";
    };
    docker = {
      enable = true;
      storageDriver = "btrfs";
    };
  };

  fileSystems = {
    "/var/storage" = {
      device = "/dev/disk/by-id/ata-CT1000MX500SSD1_1950E22EEC2F-part1";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" "subvol=storage"];
    };
    "/var/lib/docker" = {
      device = "/dev/disk/by-id/ata-CT1000MX500SSD1_1950E22EEC2F-part1";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" "subvol=docker"];
    };
    "/var/backups" = {
      device = "/dev/disk/by-label/External-backup";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" ];
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

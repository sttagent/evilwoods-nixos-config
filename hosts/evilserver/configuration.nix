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

  systemd.tmpfiles.rules = [ "d /var/storage/docker 0710 root root"];
  virtualisation = {
    oci-containers = {
      backend = "docker";
    };
    docker = {
      enable = true;
      storageDriver = "btrfs";
      daemon.settings = {
        data-root = "/var/storage/docker";
      };
    };
  };

  fileSystems = {
    "/var/storage" = {
      device = "/dev/disk/by-id/ata-CT1000MX500SSD1_1950E22EEC2F-part1";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" "subvol=storage"];
    };
    "/var/backups" = {
      device = "/dev/disk/by-label/External-backup";
      fsType = "btrfs";
      options = [ "defaults" "noatime" "compress=zstd" ];
    };
  };

  # networking.interfaces.enp3s0.useDHCP = lib.mkDefault true;
}

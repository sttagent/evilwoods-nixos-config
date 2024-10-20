let
  disks = [
    "/dev/disk/by-id/ata-SanDisk_Ultra_II_480GB_160807801275"
    "/dev/disk/by-id/ata-CT1000MX500SSD1_1950E22EEC2F"
  ];
in
{
  disko.devices = {
    disk = {
      nixos = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "5G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/";
                  };
                  "/nix" = {
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                    mountpoint = "/nix";
                  };
                  "/swap" = {
                    mountOptions = [ "noatime" ];
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "8G";
                  };
                };
              };
            };
          };
        };
      };

      data = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          partitions = {
            home = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
                  };
                  "/storage" = {
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/var/storage";
                  };
                  "/snapshots" = {
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/var/snapshots";
                  };
                  "/containers" = {
                    mountOptions = [
                      "defaults"
                      "noatime"
                      "compress=zstd"
                    ];
                    mountpoint = "/var/lib/containers";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

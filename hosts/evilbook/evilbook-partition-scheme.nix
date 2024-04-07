{ disks ? [
    "/dev/disk/by-id/ata-SanDisk_Ultra_II_480GB_160807801275"
    "/dev/disk/by-id/ata-CT1000MX500SSD1_1950E22EEC2F"
  ]
, ...
}: {
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
              end = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
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
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                  "/swap" = {
                    mountOptions = [ "noatime" ];
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "8G";
                  };
                  "home" = {
                    mountOptions = [ "compress=zstd" ];
                    mountpoint = "/home";
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

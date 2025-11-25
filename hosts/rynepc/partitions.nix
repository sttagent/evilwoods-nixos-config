{ inputs, ... }:
let
  inherit (builtins) elemAt;
  devices = [
    "/dev/vda"
  ];
in
{
  imports = [ inputs.disko.nixosModules.disko ];
  disko.devices = {
    disk = {
      nixos = {
        type = "disk";
        device = elemAt devices 0;
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
                };
              };
            };
          };
        };
      };
      home = {
        type = "disk";
        device = elemAt devices 1;
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
            "/home" = {
              mountOptions = [
                "compress=zstd"
                "noatime"
              ];
              mountpoint = "/home";
            };
          };
        };
      };
    };
  };
}

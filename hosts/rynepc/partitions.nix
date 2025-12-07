{ inputs, config, ... }:
let
  inherit (builtins) elemAt;
  inherit (config.evilwoods.vars) isTestEnv;
  devices =
    if isTestEnv then
      [
        "/dev/vda"
        "/dev/vdb"
      ]
    else
      [
        "ata-LITEON_CV3-8D128_KN1280L016636011E8HC"
        "ata-ST1000DM003-1SB102_Z9A775D4"
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

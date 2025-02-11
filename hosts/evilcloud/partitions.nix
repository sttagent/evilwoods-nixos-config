{ inputs, ... }:
let
  disks = [
    "/dev/vda"
    "/dev/vdb"
  ];
in
{
  imports = [
    inputs.disko-2411.nixosModules.disko
  ];
  disko.devices = {
    disk = {
      nixos = {
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            esp = {
              name = "ESP";
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };

      block-storage = {
        device = builtins.elemAt disks 1;
        type = "disk";
        content = {
          type = "filesystem";
          format = "xfs";
          extraArgs = [ "-f" ];
          mountpoint = "/var/storage";
          mountOptions = [
            "defaults"
            "nofail"
          ];
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [ "defaults" ];
            };
          };
        };
      };
    };
  };
}

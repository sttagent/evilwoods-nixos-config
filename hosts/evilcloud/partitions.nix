{ inputs, ... }:
let
  disks = [
    "/dev/sda"
  ];
in
{
  imports = [
    inputs.disko-stable.nixosModules.disko
  ];
  disko.devices = {
    disk = {
      main = {
        device = builtins.elemAt disks 0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            MBR = {
              priority = 0;
              size = "1M";
              type = "EF02";
            };
            ESP = {
              priority = 1;
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              priority = 2;
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}

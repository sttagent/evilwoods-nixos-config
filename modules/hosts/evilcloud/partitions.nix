{ inputs, ... }:
let
  disks = [
    "/dev/vda"
  ];
in
{
  flake.modules.nixos.diskoEvilcloud = {
    imports = [ inputs.disko-2511.nixosModules.disko ];

    disko.devices = {
      disk = {
        main = {
          device = builtins.elemAt disks 0;
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
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
                  format = "xfs";
                  mountpoint = "/";
                };
              };
            };
          };
        };
      };
    };
  };
}

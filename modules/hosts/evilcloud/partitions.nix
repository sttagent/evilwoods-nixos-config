{
  den.aspects.evilcloud.nixos = {
    disko.devices = {
      disk = {
        main = {
          device = "/dev/vda";
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

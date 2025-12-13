{ lib, ... }:
let
  inherit (lib) types mkOption;
in
{
  options = {
    evilwoods = {
      storage = {
        externalHddBackupVolume = mkOption {
          type = types.str;
          default = false;
          description = "External HDD backup volume";
        };
        externalHddSnapshotVolume = mkOption {
          type = types.str;
          default = false;
          description = "External HDD snapshot volume";
        };
        internalSsdContainersVolume = mkOption {
          type = types.str;
          default = false;
          description = "Internal SSD containers volume";
        };
        internalSsdStorageVolume = mkOption {
          type = types.str;
          default = false;
          description = "Internal SSD storage volume";
        };
        internalSsdSnapshotVolume = mkOption {
          type = types.str;
          default = false;
          description = "Internal SSD snapshot volume";
        };
      };
    };
  };
}

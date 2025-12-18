{ config, ... }:
let
  inherit (config.evilwoods.base) mainUser;
  commonOptions = [
    "x-systemd.automount"
    "x-systemd.idle-timeout=5min"
    "x-systemd.umount.force"
    "_netdev"
  ];
in
{
  boot.extraSystemdUnitPaths = [ "nfs" ];

  fileSystems = {
    "/mnt/nfs/aitvaras_share" = {
      device = "nas.evilwoods.net:/mnt/storage/shares/aitvaras";
      fsType = "nfs";
      options = commonOptions;
    };
    "/mnt/nfs/video" = {
      device = "nas.evilwoods.net:/mnt/storage/media/video";
      fsType = "nfs";
      options = commonOptions;
    };
  };

  users.groups = {
    nas_aitvaras_share = {
      gid = 4000;
      members = [ "${mainUser}" ];
    };
    nas_media = {
      gid = 4100;
      members = [ "${mainUser}" ];
    };
  };
}

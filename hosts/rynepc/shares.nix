{ config, ... }:
let
  inherit (config.evilwoods.base) mainUser;
  sharePath = "/var/storage/nfs/shares/${mainUser}";
in
{
  boot.extraSystemdUnitPaths = [ "nfs" ];

  systemd.tmpfiles.rules = [
    "d ${sharePath}"
  ];

  fileSystems = {
    "${sharePath}" = {
      device = "nas.evilwoods.net:/mnt/storage/shares/ryne";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.idle-timeout=5min"
        "x-systemd.umount.force"
        "_netdev"
      ];
    };
    # "/mnt/nfs/video" = {
    #   device = "nas.evilwoods.net:/mnt/storage/media/video";
    #   fsType = "nfs";
    #   options = [
    #     "x-systemd.automount"
    #     "x-systemd.umount.force"
    #     "_netdev"
    #   ];
    # };
  };

  users.groups = {
    nas_ryne_share = {
      gid = 4002;
      members = [ "${mainUser}" ];
    };

    nas_aitvaras_share = {
      gid = null;
    };
    nas_media = {
      gid = null;
    };
  };
}

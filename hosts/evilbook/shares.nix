{
  boot.extraSystemdUnitPaths = [ "nfs" ];

  fileSystems = {
    "/mnt/nfs/aitvaras_share" = {
      device = "nas.evilwoods.net:/mnt/storage/shares/aitvaras";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.umount.lazy"
        "_netdev"
      ];
    };
    "/mnt/nfs/video" = {
      device = "nas.evilwoods.net:/mnt/storage/media/video";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "x-systemd.umount.lazy"
        "_netdev"
      ];
    };
  };

  users.groups = {
    nas_aitvaras_share = {
      gid = 4000;
      members = [ "aitvaras" ];
    };
    nas_media = {
      gid = 4100;
      members = [ "aitvaras" ];
    };
  };
}

{
  flake.modules.nixos.aitvarasMachines =
    { config, ... }:
    let
      inherit (config.evilwoods.variables) mainUser;
      commonOptions = [
        "x-systemd.automount"
        "x-systemd.idle-timeout=5min"
        "x-systemd.umount.force"
        "_netdev"
      ];
      localSharePath = "/var/storage/nfs/shares";
      remoteSharePath = "/mnt/storage/shares";
      mainUserShare = "${localSharePath}/${mainUser}";
      videoShare = "${localSharePath}/video";
    in
    {
      boot.extraSystemdUnitPaths = [ "nfs" ];

      systemd.tmpfiles.rules = [
        "d ${mainUserShare}"
        "d ${videoShare}"
      ];

      fileSystems = {
        "${mainUserShare}" = {
          device = "nas.evilwoods.net:${remoteSharePath}/aitvaras";
          fsType = "nfs";
          options = commonOptions;
        };
        "${videoShare}" = {
          device = "nas.evilwoods.net:${remoteSharePath}/video";
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
    };
}

{

  flake.modules.nixos.ryneMachines =
    { config, ... }:
    let
      inherit (config.evilwoods.variables) mainUser;
      localSharePath = "/var/storage/nfs/shares";
      remoteSharePath = "/mnt/storage/shares";
      mainUserShare = "${localSharePath}/${mainUser}";
    in
    {
      boot.extraSystemdUnitPaths = [ "nfs" ];

      systemd.tmpfiles.rules = [
        "d ${mainUserShare}"
      ];

      fileSystems = {
        "${mainUserShare}" = {
          device = "nas.evilwoods.net:${remoteSharePath}/ryne";
          fsType = "nfs";
          options = [
            "x-systemd.automount"
            "x-systemd.idle-timeout=5min"
            "x-systemd.umount.force"
            "_netdev"
          ];
        };
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
    };
}

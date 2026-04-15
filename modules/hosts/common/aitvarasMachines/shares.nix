{ inputs, ... }:
{
  flake.modules.nixos.aitvarasMachines =
    { config, pkgs, ... }:
    let
      inherit (config.evilwoods.variables) mainUser;
      inherit (config.evilwoods.constants) evilwoodsDomain;

      # mainUserId = config.users.users.${mainUser}.uid;
      # userGroupId = config.users.groups.users.gid;
      commonOptions = [
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=60"
        "x-systemd.device-timeout=5s"
        "x-systemd.mount-timeout=5s"
        "x-systemd.umount.force"
        "_netdev"
        "nofail"
        "uid=1000"
        "gid=100"
      ];
      nasDomain = "nas.${evilwoodsDomain}";
      localSharePath = "/var/storage/shares";
      localSmbSharePath = "${localSharePath}/smb";
      mainUserShare = "${localSmbSharePath}/${mainUser}";
      backupsShare = "${localSmbSharePath}/backups";
      secretsPath = toString inputs.evilsecrets;
    in
    {
      environment.systemPackages = [ pkgs.cifs-utils ];

      sops.secrets.aitvaras-samba-share-creds = {
        sopsFile = "${secretsPath}/secrets/aitvaras/default.yaml";
        owner = "root";
        group = "root";
        mode = "0400";
      };

      systemd.tmpfiles.rules = [
        "d ${mainUserShare}"
        "d ${backupsShare}"
      ];

      fileSystems =
        let
          options = commonOptions ++ [ "credentials=${config.sops.secrets.aitvaras-samba-share-creds.path}" ];
        in
        {
          "${mainUserShare}" = {
            device = "//${nasDomain}/aitvaras";
            fsType = "cifs";
            inherit options;
          };
          "${backupsShare}" = {
            device = "//${nasDomain}/backups";
            fsType = "cifs";
            inherit options;
          };
        };
    };
}

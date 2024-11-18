let
  share_device = "/dev/disk/by-label/external-hdd";
  common_mount_options = [
    "defaults"
    "noatime"
    "compress=zstd"
  ];
in
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        security = "user";
        workgroup = "EVILWOODS";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        security = "user";
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = [
          "192.168.1."
          "127.0.0.1"
          "100."
          "localhost"
        ];
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "samba-guest";
        "map to guest" = "bad user";
      };
      public = {
        path = "/home/samba-guest/share";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "public" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "samba-guest";
        "write list" = "aitvaras ryne";
      };
      aitvaras = {
        path = "/home/aitvaras/share";
        browseable = "yes";
        "valid users" = "aitvaras";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "aitvaras";
      };
      ryne = {
        path = "/home/ryne/share";
        browseable = "yes";
        "valid users" = "ryne";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "ryne";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  users = {
    users = {
      samba-guest = {
        isSystemUser = true;
        uid = 1002;
        group = "users";
        createHome = true;
        home = "/home/samba-guest";
      };
      ryne = {
        isSystemUser = true;
        uid = 1001;
        createHome = true;
        group = "users";
        home = "/home/ryne";
      };
    };
  };

  fileSystems = {
    "/home/aitvaras/share" = {
      device = "${share_device}";
      fsType = "btrfs";
      options = [
        "subvol=shares/aitvaras"
      ] ++ common_mount_options;
    };
  };

  fileSystems = {
    "/home/ryne/share" = {
      device = "${share_device}";
      fsType = "btrfs";
      options = [
        "subvol=shares/ryne"
      ] ++ common_mount_options;
    };
  };

  fileSystems = {
    "/home/samba-guest/share" = {
      device = "${share_device}";
      fsType = "btrfs";
      options = [
        "subvol=shares/samba-guest"
      ] ++ common_mount_options;
    };
  };
}

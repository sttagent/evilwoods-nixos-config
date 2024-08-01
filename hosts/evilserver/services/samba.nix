{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = EVILWOODS
      server string = smbnix
      netbios name = smbnix
      security = user
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.1. 127.0.0.1 100. localhost
      hosts deny = 0.0.0.0/0
      guest account = samba-guest
      map to guest = bad user
    '';
    shares = {
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
      device = "/dev/disk/by-label/External-backup";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress=zstd"
        "subvol=shares/aitvaras"
      ];
    };
  };

  fileSystems = {
    "/home/ryne/share" = {
      device = "/dev/disk/by-label/External-backup";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress=zstd"
        "subvol=shares/ryne"
      ];
    };
  };

  fileSystems = {
    "/home/samba-guest/share" = {
      device = "/dev/disk/by-label/External-backup";
      fsType = "btrfs";
      options = [
        "defaults"
        "compress=zstd"
        "subvol=shares/samba-guest"
      ];
    };
  };

}

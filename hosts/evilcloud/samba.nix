{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.1. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = samba-guest
      map to guest = bad user
    '';
    shares = {
      public = {
        path = "/srv/external-backup/shares/public";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "public" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "samba-guest";
      };
      aitvaras = {
        path = "/srv/external-backup/shares/private/aitvaras";
        browseable = "yes";
        "valid users" = "aitvaras";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "aitvaras";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  users = {
    groups.samba-guest = { };
    users = {
      samba-guest = {
        uid = 1500;
        isSystemUser = true;
        createHome = false;
        group = "samba-guest";
      };
      ryne = {
        uid = 2000;
        isSystemUser = true;
        group = "users";
        createHome = false;
      };
    };
  };
}

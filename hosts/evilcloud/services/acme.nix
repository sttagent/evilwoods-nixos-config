{
  # There will to no certificates created here. Certificates will be copied from other host.
  # We want acme user in case certificates will be created here.
  users.users.acme = {
    home = "/var/lib/acme";
    group = "acme";
    isSystemUser = true;
  };

  users.groups.acme = { };

  systemd.tmpfiles.rules = [ "d /var/lib/acme 0755 acme acme" ];
}

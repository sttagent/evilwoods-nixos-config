{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
            permanent = true;
          };
        };

        websecure = {
          address = ":443";
        };
      };

      certificatesResolvers = {
        letsencrypt.acme.storage = "/var/lib/traefik/certs/acme.json";
      };
      api = {
        dashboard = true;
        insecure = true;
      };
    };
  };
}

{
  virtualisation.oci-containers.containers = {
    kitchenowl-app = {
      autoStart = true;
      image = "docker.io/tombursch/kitchenowl:v0.5.2";
      ports = [ "8081e8080" ];
      environment = {
        JWT_SECRET_KEY = "satan_spawn";
      };
      volumes = [
        "kitchenowl_data:/data"
      ];
    };
  };
}

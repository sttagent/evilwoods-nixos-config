{
  den.aspects.virtualisation.podman = {
    nixos = {
      virtualisation = {
        podman = {
          enable = true;
          autoPrune.enable = true;
        };
        oci-containers.backend = "podman";
      };
    };
  };
}

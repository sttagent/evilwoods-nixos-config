{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.evilbook = {
    stateVersion = "26.11";
    mainUser = "aitvaras";
    users.aitvaras = {
      description = "Arvydas Ramanauskas";
    };
  };

  den.aspects.evilbook = {
    includes = with den.aspects; [
      desktop.niri
      gaming.steam
      hardware.zsa
      virtualisation.podman
      shared.aitvarasMachines
      optional.tools.determinate
    ];
    nixos = {
      imports = with inputs; [
        disko.nixosModules.disko
        sops-nix.nixosModules.default
      ];
    };
  };
}

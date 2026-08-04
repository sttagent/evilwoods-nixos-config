{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.evilbook = {
    channel = "nixos-unstable";
    stateVersion = "26.11";
    mainUser = "aitvaras";
    users.aitvaras = {
      description = "Arvydas Ramanauskas";
    };
  };

  den.aspects.evilbook = {
    includes = with den.aspects; [
      role.desktop
      desktop-environment.niri

      gaming.steam
      hardware.zsa
      virtualisation.podman
      aitvaras-machines.shares
      tools.determinate
    ];
    nixos = {
      imports = with inputs; [
        disko.nixosModules.disko
        sops-nix.nixosModules.default
      ];
    };
  };
}

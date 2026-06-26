{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.evilbook = {
    stateVersion = "26.11";
    mainUser = "aitvaras";
    users.aitvaras = { };
  };

  den.aspects.evilbook = {
    includes = with den.aspects; [
      desktop.cosmic
      gaming.steam
      hardware.zsa
      virtualisation.podman
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

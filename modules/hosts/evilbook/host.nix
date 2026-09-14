{ inputs, den, ... }:
{
  den.hosts.x86_64-linux.evilbook = {
    channel = "nixos-unstable";
    stateVersion = "26.11";
    mainUser = "aitvaras";
    users.aitvaras = {
      description = "Arvydas Ramanauskas";
      extraGroups = [ "libvirt" ];
    };
  };

  den.aspects.evilbook = {
    includes = with den.aspects; [
      # roles.desktop.noctalia
      # roles.desktop.umbriel
      (roles.desktop.wm {
        shell = "noctalia";
        wm = "umbriel";
      })

      networking.wifi.evilHome
      networking.wifi.stthotspot
      networking.wifi.degerman

      gaming.steam
      gaming.minecraft

      hardware.zsa
      virtualisation.podman
      virtualisation.qemu
      aitvaras-machines.shares
      tools.determinate
    ];
    nixos = { lib, ... }: {
      imports = with inputs; [
        disko.nixosModules.disko
        sops-nix.nixosModules.default
      ];
      # home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];

      # overrides
      boot.plymouth.enable = lib.mkForce false;
    };
  };
}

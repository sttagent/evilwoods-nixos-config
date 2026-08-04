{ inputs, den, ... }: {
  den.hosts.x86_64-linux.rynepc = {
    channel = "nixos-unstable";
    stateVersion = "25.11";
    mainUser = "admin";
    users = {
      admin = {
        uid = 1000;
      };
      ryne = {
        uid = 1001;
      };
    };
  };

  den.aspects.rynepc = {
    includes = with den.aspects; [
      role.desktop
      desktop-environment.gnome
      gaming.steam
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

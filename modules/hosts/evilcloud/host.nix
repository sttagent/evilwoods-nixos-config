{ inputs, den, ... }: {
  den.hosts.x86_64-linux.evilcloud = {
    stateVersion = "26.05";
    mainUser = "admin";
    users.admin = { };
  };

  den.aspects.evilcloud = {
    instantiate = inputs.nixpkgs-2605.lib.nixosSystem;
    home-manager.module = inputs.home-manager-2605.nixosModules.home-manager;

    includes = with den.aspects; [
      server
      vmGuest
      optional.tools.determinate
    ];

    nixos = {
      imports = with inputs; [
        disko-2605.nixosModules.disko
        sops-nix-2605.nixosModules.default
      ];
    };
  };
}

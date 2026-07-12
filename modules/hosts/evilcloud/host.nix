{ inputs, den, ... }: {
  den.hosts.x86_64-linux.evilcloud = {
    instantiate = inputs.nixpkgs-2605.lib.nixosSystem;
    home-manager.module = inputs.home-manager-2605.nixosModules.home-manager;
    stateVersion = "26.05";
    mainUser = "admin";
    users = {
      admin = {
        uid = 1000;
      };
    };
  };

  den.aspects.evilcloud = {
    includes = with den.aspects; [
      server
      vmGuest

      optional.tools.determinate

      services.fail2ban
      services.nixos-runner
    ];

    nixos = {
      imports = with inputs; [
        disko-2605.nixosModules.disko
        sops-nix-2605.nixosModules.default
      ];
    };
  };
}

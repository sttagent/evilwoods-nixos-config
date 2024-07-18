{ inputs, ... }:
let
  evilib = inputs.self.lib;

  mkHost = { hostname, users ? [ ], nixpkgs, stateVersion, extraModules ? [ ], ... }:
  {
    name = "${hostname}";
    value = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ../modules

        ../users/${evilib.mainUser}-${hostname}
        ./${hostname}

        {
          networking.hostName = hostname;
          system.stateVersion = stateVersion;
        }
      ] ++ extraModules;

      specialArgs = {
        inherit inputs evilib;
      };
    };
  };

  mkHosts = hostList: builtins.map mkHost hostList;
in
builtins.listToAttrs (mkHosts [
  {
    hostname = "evilbook";
    nixpkgs = inputs.nixpkgs-unstable;
    stateVersion = "24.05";
    extraModules = [
      inputs.disko.nixosModules.disko
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
    ];
  }

  {
    hostname = "evilcloud";
    nixpkgs = inputs.nixpkgs-2405;
    stateVersion = "24.05";
    extraModules = [
      inputs.disko-2405.nixosModules.disko
      inputs.home-manager-2405.nixosModules.home-manager
      inputs.sops-nix-2405.nixosModules.sops
    ];
  }

  {
    hostname = "evilcloud-bootstrap";
    nixpkgs = inputs.nixpkgs-2405;
    stateVersion = "24.05";
    extraModules = [
      inputs.disko-2405.nixosModules.disko
      inputs.sops-nix-2405.nixosModules.sops
    ];
  }
])

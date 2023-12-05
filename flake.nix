{
  description = "Evilwoods nixos config";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];

    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs =
    { self
    , nixpkgs-stable
    , nixpkgs-unstable
    , disko
    , home-manager
    , sops-nix
    , nixos-hardware
    , ...
    } @ inputs:
    let
      evilLib = import ./lib {lib = nixpkgs-unstable.legacyPackages.x86_64-linux.lib;};
    in
    {
      lib = evilLib;
      nixosConfigurations = {
        evilroots = let nixpkgs = nixpkgs-unstable; in nixpkgs.lib.nixosSystem {
          system = evilLib.defaultSystem;
          specialArgs = inputs;

          modules = [
            # Nixos community modules
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager

            # My custom modules
            ./modules

            # Machine configuration
            ./hosts
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs-unstable.legacyPackages.x86_64-linux.nixpkgs-fmt;

    };
}

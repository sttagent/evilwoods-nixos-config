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
    {
      formatter.x86_64-linux = nixpkgs-unstable.legacyPackages.x86_64-linux.nixpkgs-fmt;

      lib = import ./lib { lib = nixpkgs-unstable.lib; };

      nixosModules = { };

      nixosConfigurations = import ./hosts {
        inherit inputs;
        extraModules = [
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
        ];
      };

      diskoConfigurations = {
        evilroots = import ./hosts/evilroots/evilroots-partition-scheme.nix;
        evilbook = import ./hosts/evilbook/evilbook-partition-scheme.nix;
      };
    };
}

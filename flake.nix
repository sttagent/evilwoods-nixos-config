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
    nixpkgs-2311.url = "nixpkgs/nixos-23.11";

    home-manager-2311 = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-2311";
    };

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
    , nixpkgs-2311
    , nixpkgs-unstable
    , disko
    , home-manager
    , home-manager-2311
    , sops-nix
    , nixos-hardware
    , ...
    } @ inputs:
    let
      pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;
    in
    {
      formatter.x86_64-linux = pkgs.nixpkgs-fmt;

      lib = import ./lib { lib = nixpkgs-unstable.lib; };

      nixosModules = { };

      nixosConfigurations = import ./hosts { inherit inputs; };

      diskoConfigurations = {
        evilroots = import ./hosts/evilroots/evilroots-partition-scheme.nix;
        evilbook = import ./hosts/evilbook/evilbook-partition-scheme.nix;
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "nixos-config";
        nativeBuildInputs = with pkgs; [
          nixd
        ];
      };
    };
}

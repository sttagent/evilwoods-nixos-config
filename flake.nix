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
    /*  */
    # sops-nix is a tool for managing secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, disko, home-manager, sops-nix, ... } @ inputs:
    let
      evilLib = import ./lib;
    in
    {
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
            ./machines/evilroots.nix
          ];
        };
      };

      formatter.x86_64-linux = nixpkgs-unstable.legacyPackages.x86_64-linux.nixpkgs-fmt;

      devShells.x86_64-linux = let pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux; in {
        django = pkgs.mkShell {
          buildInputs = with pkgs; [ python3 python3Packages.django python3Packages.flask ];
        };
      };
    };
}

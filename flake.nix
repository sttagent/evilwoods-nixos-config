{
  description = "Evilwoods nixos config";

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
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, disko, home-manager, ... } @ inputs: 
  let
    evilLib = import ./lib;
  in {
    nixosConfigurations = {
      evilroots =
        let
          nixpkgs = nixpkgs-unstable;
        in nixpkgs.lib.nixosSystem {
        system = evilLib.defaultSystem;
        specialArgs = inputs;

        modules = [
          disko.nixosModules.disko
          ./evilroots-partition-scheme.nix
          {
            _module.args.disks = [ "/dev/sdb" ];
          }

          ./modules

          ./machines/evilroots.nix

	        home-manager.nixosModules.home-manager
	        {
	          home-manager = {
	            useGlobalPkgs = true;
	            useUserPackages = true;
	            users.aitvaras = import ./home.nix;
	          };
	        }
        ];
      };
    };
  };
}

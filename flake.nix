{
  description = "Evilwoods nixos config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, nixpkgs-unstable, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      evilroots = lib.nixosSystem {
        inherit system;

	modules = [
	  ./configuration.nix
	];
      };
    };
  };
}

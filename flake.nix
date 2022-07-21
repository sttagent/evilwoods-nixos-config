{
  description = "Evilwoods nixos config";


  inputs = {

    nixpkgs.url = "nixpkgs/nixos-22.05";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };


  outputs = { self, nixpkgs, nixpkgs-unstable, ... } @ inputs: 

  let
  
    system = "x86_64-linux";

    pkgs = import nixpkgs {

      inherit system;

      config = { allowUnfree = true; };
    };

    pkgsUnstable = import nixpkgs-unstable {

      inherit system;

      config = { allowUnfree = true; };
    };

  in {

    nixosConfigurations = {

      evilroots = nixpkgs.lib.nixosSystem {

        inherit system;

	specialArgs = { inherit pkgsUnstable; };

	modules = [
	  ./configuration.nix
	  {
	    imports = [
	      ./modules
	    ];

	    nixpkgs.pkgs = pkgs;

	    sys.ssh.enable = true;

	    sys.desktop.enable = true;

            sys.zsa.enable = true;

	    hardware.steam-hardware.enable = true;

	    # Version when when the os was installed.
            system.stateVersion = "22.05"; # Did you read the comment?
	  }
	];
      };
    };
  };
}

{
  description = "Evilwoods nixos config";


  inputs = {

    nixpkgs-22-05.url = "nixpkgs/nixos-22.05";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };


  outputs = { self, nixpkgs-22-05, nixpkgs-unstable, ... } @ inputs: 

  let
    myLib = import ./lib;

    allPkgs = {
      "22-05" = myLib.mkPkgs { channel = nixpkgs-22-05; };

      unstable = myLib.mkPkgs { channel = nixpkgs-unstable; };
    };
  
  in {

    nixosConfigurations = {

      evilroots = nixpkgs-unstable.lib.nixosSystem {

        system = "x86_64-linux";

	specialArgs = { inherit allPkgs; };

	modules = [
	  ./configuration.nix

	  {
	    imports = [
	      ./modules
	    ];

	    networking.hostName = "evilroots";

	    nixpkgs.pkgs = allPkgs.unstable;

	    evilcfg.ssh = true;

	    evilcfg.desktop = true;

	    evilcfg.steam = true;

            evilcfg.zsa = true;

	    hardware.steam-hardware.enable = true;

	    # Version when when the os was installed. Future updates 
            system.stateVersion = "22.05"; # Did you read the comment?
	  }
	];
      };
    };
  };
}

{
  description = "Evilwoods nixos config";

  inputs = {
    nixpkgs-22-05.url = "nixpkgs/nixos-22.05";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  };


  outputs = { self, nixpkgs-22-05, nixpkgs-unstable, ... } @ inputs: 
  let
    evilLib = import ./lib;

    allPkgs = {
      "22-05" = evilLib.mkPkgs { channel = nixpkgs-22-05; };

      unstable = evilLib.mkPkgs { channel = nixpkgs-unstable; };
    };
  
  in {

    nixosConfigurations = {

      evilroots = nixpkgs-unstable.lib.nixosSystem {

        system = evilLib.defaultSystem;

	specialArgs = { inherit allPkgs; };

	modules = [
          ./modules

	  ./configuration.nix

	  {
	    networking.hostName = "evilroots";

	    nixpkgs.pkgs = allPkgs.unstable;

	    evilcfg.ssh = true;

	    evilcfg.desktop = true;

	    evilcfg.steam = true;

            evilcfg.zsa = true;

	    fileSystems."/home/aitvaras/localdata" = {
	      device = "/dev/disk/by-label/NIXOS";
	      fsType = "btrfs";
	      options = [ "subvol=data" "compress=zstd" "noatime" ];
	    };

	    # Version of NixOS installed from live disk. Needed for backwards compatability.
            system.stateVersion = "22.05"; # Did you read the comment?
	  }
	];
      };
    };
  };
}

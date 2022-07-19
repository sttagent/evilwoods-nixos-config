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
	    sys.desktop.enable = true;

            security.pam.services.aitvaras.enableGnomeKeyring = true;

	    services.udev.packages = [ pkgs.yubikey-personalization ];

	    hardware.steam-hardware.enable = true;

	    networking.firewall.checkReversePath = "loose";
	    services.tailscale.enable = true;

	    users.users.aitvaras.packages = [
	    ];

	    # Version installed. Future updates 
            system.stateVersion = "22.05"; # Did you read the comment?
	  }
	];
      };
    };
  };
}

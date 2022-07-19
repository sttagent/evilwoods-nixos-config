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
    unstable = import nixpkgs-unstable {
      inherit system;
      config = { allowUnfree = true; };
    };

  in {
    nixosConfigurations = {
      evilroots = nixpkgs.lib.nixosSystem {
        inherit system;

	specialArgs = inputs;

	modules = [
	  ./configuration.nix
	  {
	    imports = [
	      ./modules
	    ];
            security.pam.services.aitvaras.enableGnomeKeyring = true;

	    services.udev.packages = [ pkgs.yubikey-personalization ];

	    hardware.steam-hardware.enable = true;

	    networking.firewall.checkReversePath = "loose";
	    services.tailscale.enable = true;

	    users.users.aitvaras.packages = [
	      unstable.thunderbird-wayland
	      unstable.protonvpn-gui
	    ];

	    # Version installed. Future updates n
            system.stateVersion = "22.05"; # Did you read the comment?
	  }
	];
      };
    };
  };
}

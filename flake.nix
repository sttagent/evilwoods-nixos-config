{
  description = "Evilwoods nixos config";

  inputs = {
    nixpkgs-2411.url = "nixpkgs/nixos-24.11";
    home-manager-2411 = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    disko-2411 = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-2411";
    };
    sops-nix-2411 = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-2411";
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

    evilsecrets = {
      url = "git+ssh://git@github.com/sttagent/evilwoods-nixos-config-secrets.git";
      flake = false;
    };
  };

  outputs =
    inputs:
    let
      pkgs = import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        overlay = import ./overlays/pythonPackages.nix;
      };
      evilib = import ./lib { inherit inputs; };
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      lib = evilib;

      overlays = {
        myPackages = import ./overlays/pythonPackages.nix;
      };

      nixosConfigurations = import ./hosts {
        inherit inputs;
        inherit (pkgs) lib;
      };

      devShells.x86_64-linux.default = import ./shell.nix {
        inherit pkgs;
      };
    };
}

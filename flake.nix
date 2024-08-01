{
  description = "Evilwoods nixos config";

  inputs = {
    nixpkgs-2405.url = "nixpkgs/nixos-24.05";

    home-manager-2405 = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    disko-2405 = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-2405";
    };
    sops-nix-2405 = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-2405";
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
      pkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      lib = import ./lib { lib = inputs.nixpkgs-unstable.lib; };

      nixosConfigurations = import ./hosts {
        inherit inputs;
        hosts = [
          {
            hostname = "evilbook";
            bootstrap = false;
            nixpkgs = inputs.nixpkgs-unstable;
            stateVersion = "24.05";
            extraModules = [
              inputs.disko.nixosModules.disko
              inputs.home-manager.nixosModules.home-manager
              inputs.sops-nix.nixosModules.sops
            ];
          }
          {
            hostname = "evilserver";
            bootstrap = true;
            nixpkgs = inputs.nixpkgs-2405;
            stateVersion = "24.05";
            extraModules = [
              inputs.disko-2405.nixosModules.disko
              inputs.home-manager-2405.nixosModules.home-manager
              inputs.sops-nix-2405.nixosModules.sops
            ];
          }
          {
            hostname = "evilcloud";
            bootstrap = true;
            nixpkgs = inputs.nixpkgs-2405;
            stateVersion = "24.05";
            extraModules = [
              inputs.disko-2405.nixosModules.disko
              inputs.home-manager-2405.nixosModules.home-manager
              inputs.sops-nix-2405.nixosModules.sops
            ];
          }
        ];
      };

      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "evilwoods-nixos-config";
        packages = with pkgs; [
          nixd
          nix-output-monitor
          nvd
          sops
          nixfmt-rfc-style
          nixpkgs-fmt
          ssh-to-age
        ];
      };
    };
}

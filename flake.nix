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

    cachix-deploy = {
      url = "github:cachix/cachix-deploy-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    evilsecrets = {
      url = "git+ssh://git@github.com/sttagent/evilwoods-nixos-config-secrets.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-2411,
      cachix-deploy,
      ...
    }@inputs:
    let
      pkgs = nixpkgs-unstable.legacyPackages.${system}.extend (import ./overlays/pythonPackages.nix);
      evilib = import ./lib { inherit inputs; };
      cachix-deploy-lib = cachix-deploy.lib pkgs;
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      lib = evilib;

      checks.x86_64-linux.evilserver_test = pkgs-stable.testers.runNixOSTest (
        import ./hosts/evilserver/test.nix { inherit inputs; }
      );

      nixosConfigurations = evilib.mkHosts ./hosts;

      packages.${system} = {
        cachix-deploy-spec = cachix-deploy-lib.spec {
          agents = {
            evilcloud = self.nixosConfigurations.evilcloud.config.system.build.toplevel;
          };
        };
      };

      devShells.x86_64-linux.default = import ./shell.nix {
        inherit pkgs;
      };
    };
}

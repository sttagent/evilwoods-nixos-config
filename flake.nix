{
  description = "Evilwoods nixos config";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager-2505 = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-2505";
    };
    disko-2505 = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-2505";
    };
    sops-nix-2505 = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-2505";
    };

    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
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

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # cachix-deploy = {
    #   url = "github:cachix/cachix-deploy-flake";
    #   inputs.nixpkgs.follows = "nixpkgs-unstable";
    # };

    evilsecrets = {
      url = "git+ssh://git@github.com/sttagent/evilwoods-nixos-config-secrets.git";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixpkgs-2505,
      nixos-generators,
      # cachix-deploy,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs-unstable.legacyPackages.${system}.extend (import ./overlays/pythonPackages.nix);
      evilib = import ./lib { inherit inputs; };
      # cachix-deploy-lib = cachix-deploy.lib pkgs;
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt-rfc-style;

      lib = evilib;

      nixosConfigurations = evilib.mkHosts ./hosts;

      # packages.${system} = {
      #   cachix-deploy-spec = cachix-deploy-lib.spec {
      #     agents = {
      #       evilcloud = self.nixosConfigurations.evilcloud.config.system.build.toplevel;
      #     };
      #   };

      #   # bootStrapISO = nixos-generators.nixosGenerate { };
      # };

      devShells.x86_64-linux.default = import ./shell.nix {
        inherit pkgs;
      };
    };
}

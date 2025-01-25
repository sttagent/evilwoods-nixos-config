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
      pkgs = inputs.nixpkgs-unstable.legacyPackages.x86_64-linux;
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

      # TODO: import shell instead
      devShells.x86_64-linux.default = pkgs.mkShell {
        name = "evilwoods-nixos-config";
        packages = with pkgs; [
          nixd
          nix-output-monitor
          nvd
          nixfmt-rfc-style
          nixpkgs-fmt
          ssh-to-age
          sops
          jq
          meld
          python312Packages.python-lsp-server
          lua-language-server
        ];
      };
    };
}

{
  description = "Evilwoods nixos config";

  inputs = {
    nixpkgs-2505.url = "nixpkgs/nixos-25.05";
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
    {
      self,
      nixpkgs-unstable,
      nixpkgs-2505,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs-unstable.legacyPackages.${system}.extend (import ./overlays/pythonPackages.nix);
      evilib = import ./lib { inherit inputs; };
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt;

      lib = evilib;

      nixosConfigurations = evilib.mkHosts ./hosts;

      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          name = "evilwoods-nixos-config";
          packages = with pkgs; [
            nixd
            nix-output-monitor
            nvd
            nixfmt
            jq
            python3Packages.python-lsp-server
            basedpyright
            ruff
            python3Packages.questionary
            lua-language-server
            nixos-option
            nix-tree
            statix
          ];
        };
        install_env = import ./shell.nix {
          inherit pkgs;
        };
      };
    };
}

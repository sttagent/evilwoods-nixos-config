{

  description = "Evilwoods nixos config";

  inputs = {
    nixkpgs-25-11.url = "nixpkgs/nixos-25.11";
    home-manager-25-11 = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixkpgs-25-11";
    };
    disko-25-11 = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixkpgs-25-11";
    };
    sobs-nix-25-11 = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixkpgs-25-11";
    };

    # nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";

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

    niks3.url = "github:Mic92/niks3";

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # quadlet-nix.url = "github:SEIAROTg/quadlet-nix";

    evilsecrets = {
      url = "git+ssh://git@github.com/sttagent/evilwoods-nixos-config-secrets.git";
      flake = false;
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs-unstable,
      nixkpgs-25-11,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs-unstable.legacyPackages.${system};
      evilib = import ./lib { inherit inputs; };

      commonNixOSModules = [
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager
        inputs.noctalia.nixosModules.default
        inputs.determinate.nixosModules.default
      ];
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt;

      lib = evilib;

      nixosConfigurations = evilib.mkHosts commonNixOSModules ./hosts;

      packages.x86_64-linux = {
        setup-install-env = pkgs.writeShellApplication {
          name = "setup-install-env";
          runtimeInputs = with pkgs; [
            git
          ];
          text = builtins.readFile ./scripts/setup-install-env.bash;
        };
      };

      devShells.x86_64-linux = {
        default = pkgs.mkShell {
          name = "evilwoods-nixos-config";
          packages = with pkgs; [
            nixd
            nix-output-monitor
            nvd
            nixfmt
            jq
            (python3.withPackages (
              ps: with ps; [
                questionary
                python-lsp-server
              ]
            ))
            basedpyright
            ruff
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

{

  description = "Evilwoods nixos config";

  inputs = {
    # Stable branch of nixpkgs
    # nixpkgs-2511.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-2511.url = "https://flakehub.com/f/NixOS/nixpkgs/*";
    home-manager-2511 = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-2511";
    };
    disko-2511 = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-2511";
    };
    sops-nix-2511 = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-2511";
    };

    # Unstable branch of nixpkgs
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Misc tools, utilities and modules
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niks3 = {
      url = "github:Mic92/niks3";
      inputs.nixpkgs.follows = "nixpkgs-2511";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
    };
    # quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
    # Sops-nix secrets
    evilsecrets = {
      url = "git+ssh://git@github.com/sttagent/evilwoods-nixos-config-secrets?ref=main";
      flake = false;
    };
  };

  outputs =
    {
      flake-parts,
      import-tree,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (import-tree ./modules);
}

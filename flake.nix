{

  description = "Evilwoods nixos config";

  inputs = {
    # flake utilities
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Stable branch of nixpkgs
    nixpkgs-2511.url = "github:NixOS/nixpkgs/nixos-25.11";
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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      url = "git+ssh://git@codeberg.org/mandatory2/evilwoods-nixos-config-secrets.git";
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

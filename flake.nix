# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    den.url = "github:denful/den/v0.17.0";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko-2605 = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-2605";
    };
    evilsecrets = {
      url = "git+ssh://git@github.com/sttagent/evilwoods-nixos-config-secrets?ref=main";
      flake = false;
    };
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager-2605 = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-2605";
    };
    import-tree.url = "github:vic/import-tree";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niks3 = {
      url = "github:Mic92/niks3";
      inputs.nixpkgs.follows = "nixpkgs-2605";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    nixpkgs-2605.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2605";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix-2605 = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-2605";
    };
  };
}

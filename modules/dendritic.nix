{ inputs, ... }:
{
  imports = [
    (inputs.flake-file.flakeModules.dendritic or { })
    (inputs.den.flakeModules.dendritic or { })
  ];

  # other inputs may be defined at a module using them.
  flake-file.inputs = {
    den.url = "github:denful/den/v0.18.0";
    flake-file.url = "github:vic/flake-file";
    nixpkgs-2605.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2605";
    home-manager-2605 = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs-2605";
    };
    disko-2605 = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-2605";
    };
    sops-nix-2605 = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-2605";
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
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niks3 = {
      url = "github:Mic92/niks3";
      inputs.nixpkgs.follows = "nixpkgs-2605";
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
}

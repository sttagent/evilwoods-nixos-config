{
  inputs,
  self,
  lib,
  ...
}:
{
  options.hosts.hostRynepc.nixpkgs = lib.mkOption {
    type = lib.types.str;
    default = "nixpkgs";
  };

  config.flake = {
    modules.nixos.hostRynepc = {
      imports =
        with inputs;
        with self.modules.nixos;
        [
          gnome
          steam
          diskoRynepc
          ryneMachines

          # Users
          self.modules.nixos."userRyne@rynepc"
          self.modules.nixos."userAdmin@rynepc"

          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
        ];
    };
  };
}

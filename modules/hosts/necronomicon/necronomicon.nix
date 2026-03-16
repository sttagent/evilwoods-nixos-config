{
  self,
  inputs,
  lib,
  ...
}:
{
  options.hosts.hostNecronomicon.nixpkgs = lib.mkOption {
    type = lib.types.str;
    default = "nixpkgs";
  };
  config.flake.modules.nixos.hostNecronomicon = {
    imports =
      with inputs;
      with self.modules.nixos;
      [
        # local nixos modules
        gnome
        steam
        diskoNecronomicon
        ryneMachines

        # users
        self.modules.nixos."userRyne@necronomicon"
        self.modules.nixos."userAdmin@necronomicon"

        # external nixos modules
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
      ];
  };
}

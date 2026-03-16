{
  inputs,
  lib,
  self,
  ...
}:
{
  options.hosts.hostEvilbook.nixpkgs = lib.mkOption {
    type = lib.types.str;
    default = "nixpkgs";
  };

  config.flake = {
    modules.nixos.hostEvilbook = {
      imports =
        with inputs;
        with self.modules.nixos;
        [
          # local Nixos modules
          # cosmic
          cosmic
          steam
          hardwareZSA
          hardwareAndroid
          diskoEvilbook
          aitvarasMachines

          microvms

          # users
          self.modules.nixos."userAitvaras@evilbook"

          # external Nixos modules
          determinate.nixosModules.default
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager
        ];
    };
  };
}

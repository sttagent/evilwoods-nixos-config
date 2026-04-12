{
  inputs,
  lib,
  self,
  ...
}:
{
  options.hosts.hostEvilcloud.nixpkgs = lib.mkOption {
    type = lib.types.str;
    default = "nixpkgs-2511";
  };

  config.flake = {
    modules.nixos.hostEvilcloud = {
      imports =
        with inputs;
        with self.modules.nixos;
        [
          # local Nixos modules
          diskoEvilcloud
          server
          vmGuest

          # services
          serviceFail2ban
          serviceAdGuardHome
          # serviceForgejoRunner
          serviceNtfy
          serviceTraefik
          serviceSearx
          serviceNiks3

          # users
          self.modules.nixos."userAitvaras@evilcloud"

          # external Nixos modules
          sops-nix-2511.nixosModules.sops
          home-manager-2511.nixosModules.home-manager
        ];
    };
  };
}

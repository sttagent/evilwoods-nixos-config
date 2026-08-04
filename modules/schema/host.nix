{
  den,
  inputs,
  lib,
  ...
}:
let
  inherit (lib) mkOption types;

  channels = {
    nixos-unstable = {
      nixosSystem = inputs.nixpkgs.lib.nixosSystem;
      homeManagerModule = inputs.home-manager.nixosModules.home-manager;
      # sopsNixModule = inputs.sops-nix.nixosModules.sops;
    };
    nixos-2605 = {
      nixosSystem = inputs.nixpkgs-2605.lib.nixosSystem;
      homeManagerModule = inputs.home-manager-2605.nixosModules.home-manager;
      # sopsNixModule = inputs.sops-nix-2605.nixosModules.sops;
    };
  };
  channelNames = builtins.attrNames channels;
in
{
  den.schema.host = {
    home-manager.enable = true;

    includes = [
      den.policies.home-manager-state-version
      den.aspects.core.hosts
    ];

    imports = [
      (
        { config, ... }:
        let
          channel = channels.${config.channel};
        in
        {
          options = {
            channel = mkOption {
              type = types.enum channelNames;
            };
            stateVersion = mkOption {
              type = types.str;
            };
            mainUser = mkOption {
              type = types.str;
            };
          };
          config = {
            instantiate = channel.nixosSystem;
            home-manager.module = channel.homeManagerModule;
          };
        }
      )
    ];
  };
}

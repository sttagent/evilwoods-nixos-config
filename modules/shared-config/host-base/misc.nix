{ inputs, ... }: {
  den.aspects.hostBase = {
    nixos =
      { lib, ... }:
      let
        inherit (lib) mkDefault;
        secretsPath = toString inputs.evilsecrets;
      in
      {
        nix = {
          settings = {
            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];
            warn-dirty = false;
            allowed-users = [ "@wheel" ];
            substituters = [
              "https://cache.nixos.org"
              "https://nix-community.cachix.org/"
              # "https://cache.evilwoods.net/"
              #"https://evilwoods.cachix.org/"
            ];
            trusted-public-keys = [
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "evilwoods.cachix.org-1:o+vo0Td8pumN3mT5OEnicUQYTkhw4icQYIDgprBXWaI="
              "cache.evilwoods.net-1:YgsjoMYmHvVsg2E7zUiBw5k33VRsVOoBhSaNEc/fTJE="
            ];
          };

          # Garbage collection
          gc = {
            automatic = mkDefault true;
            dates = mkDefault "weekly";
            options = mkDefault "--delete-older-than 30d";
            persistent = mkDefault true;
          };
        };

        sops = {
          defaultSopsFile = "${secretsPath}/secrets/common/default.yaml";
          validateSopsFiles = false;
          age = {
            sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            keyFile = "/var/lib/sops-nix/key.txt";
            generateKey = true;
          };
        };

        nixpkgs.config.allowUnfree = mkDefault true;

        time.timeZone = "Europe/Stockholm";

        services = {
          dbus.implementation = "broker";

          userborn.enable = mkDefault true;
        };

        # disable user creation. needed to disable root account
        users.mutableUsers = mkDefault false;
        # disable root account
        users.users.root = {
          hashedPassword = mkDefault "!";
        };
      };
  };
}

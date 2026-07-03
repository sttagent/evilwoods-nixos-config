{
  inputs,
  ...
}:
{
  den.aspects.evilcloud.nixos =
    {
      host,
      lib,
      ...
    }:
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
            "https://nix-community.cachix.org/"
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
          persistent = true;
        };
      };

      sops = {
        defaultSopsFile = "${secretsPath}/secrets/hosts/common.yaml";
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

        userborn.enable = true;

        openssh = {
          enable = mkDefault true;
          settings = {
            PermitRootLogin = "no";
            PasswordAuthentication = false;
          };
        };
      };

      # disable user creation. needed to disable root account
      users.mutableUsers = false;
      # disable root account
      users.users.root = {
        hashedPassword = "!";
      };

      boot = {
        loader = {
          efi = {
            canTouchEfiVariables = true;
          };
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
          };
        };
      };

      system.stateVersion = host.stateVersion;
    };
}

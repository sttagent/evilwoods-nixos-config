{
  inputs,
  ...
}:
{
  flake.modules.nixos.hostEvilcloud =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      inherit (lib) mkDefault;
      secretsPath = toString inputs.evilsecrets;
    in
    {
      # host specific variables
      evilwoods = {
        variables = {
          mainUser = "aitvaras";
        };
      };

      environment.systemPackages = with pkgs; [
        bottom
        zoxide
        neovim
        zellij
        atuin
        ripgrep
        fd
        sd
        bat
        eza
        fzf
        wget
        git
        gnupg
        dust
        just
        difftastic
        nix-tree
        nixos-option
        cachix
        jq
      ];

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
            "https://evilwoods.cachix.org/"
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

      programs.fish.enable = true;

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

      system.stateVersion = "25.11";
    };
}

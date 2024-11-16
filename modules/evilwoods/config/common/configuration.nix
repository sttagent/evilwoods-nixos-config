{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
    ;

  secretsPath = builtins.toString inputs.evilsecrets;

  cfg = config.evilwoods.config.common;
in
{
  options = {
    evilwoods.config.common = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable common configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    evilwoods.config.tailscale.enable = true;

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
    ];

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
        allowed-users = [ "@wheel" ];
        trusted-substituters = [ "https://nix-community.cachix.org/" ];

        extra-substituters = [
          # Nix community's cache server
          "https://nix-community.cachix.org/"
        ];

        extra-trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
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
      defaultSopsFile = "${secretsPath}/secrets/default.yaml";
      validateSopsFiles = false;
      age = {
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };
    };

    nixpkgs.config.allowUnfree = mkDefault true;

    networking = {
      useDHCP = mkDefault true;
      firewall = {
        enable = mkDefault true;
      };
      enableIPv6 = mkDefault false;
    };

    time.timeZone = "Europe/Stockholm";

    services = {
      dbus.implementation = "broker";

      openssh = {
        enable = mkDefault true;
        settings = {
          PasswordAuthentication = mkDefault false;
        };
      };
    };

    # nextdns configuration

    # disable user creation. needed to disable root account
    users.mutableUsers = false;
    # disable root account
    users.users.root = {
      hashedPassword = "!";
    };

    programs.fish.enable = true;
  };
}

{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkDefault;
  inherit (builtins) toString;
  secretsPath = toString inputs.evilsecrets;
in
{

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
        "evilwoods.cachix.org-1:+kVRzmuwRwB+nTxSeBhtG5t2QyD7qyiD53SxhhjEj5o="
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
    defaultSopsFile = "${secretsPath}/secrets/commmon/default.yaml";
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
}

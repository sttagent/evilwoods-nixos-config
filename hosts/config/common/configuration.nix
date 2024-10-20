{ pkgs, lib, ... }:
let
  inherit (lib) mkDefault;
in
{
  nix = {
    package = mkDefault pkgs.nixFlakes;
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

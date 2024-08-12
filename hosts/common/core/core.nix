{ inputs
, config
, pkgs
, lib
, ...
}:
{
  nix = {
    package = pkgs.nixFlakes;
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
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  networking = {
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = lib.mkDefault true;
    };
  };

  time.timeZone = "Europe/Stockholm";

  services = {
    openssh = {
      enable = lib.mkDefault true;
      settings = {
        PasswordAuthentication = lib.mkDefault false;
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

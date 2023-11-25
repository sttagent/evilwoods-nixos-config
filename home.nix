{config, pkgs, ...}: {
  home = {
    username = "aitvaras";
    homeDirectory = "/home/aitvaras";

    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;

    git = {
     enable = true;
     userName = "Arvydas Ramanauskas";
     userEmail = "arvydas.ramanauskas@evilwoods.net";
    };

    fish = {
      enable = true;
    };

    atuin = {
      enable = true;
      enableFishIntegration = true;
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}

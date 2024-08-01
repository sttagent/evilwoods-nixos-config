{ config, pkgs, ... }@args:
let
  inherit (import ./vars.nix) thisUser;
in
{
  imports = [
    ../common
    ./home.nix
    # ./nvim.nix
  ];

  sops.secrets.aitvaras-password.neededForUsers = true;

  users.users = {
    ${thisUser} = {
      isNormalUser = true;
      createHome = true;
      home = "/home/${thisUser}";
      description = "Arvydas Ramanauskas";
      hashedPasswordFile = config.sops.secrets.aitvaras-password.path;
      extraGroups = [
        "wheel"
        "networkmanager"
      ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
    };
  };
}

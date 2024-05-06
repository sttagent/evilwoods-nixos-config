{ config, pkgs, ... }@args:
let
  thisUser = "aitvaras";
in
{
  imports = [
    ./home.nix
    ./nvim.nix
  ];

  sops.secrets.aitvaras-password.neededForUsers = true;

  users.users = {
    ${thisUser} = {
      isNormalUser = true;
      description = "Arvydas Ramanauskas";
      hashedPasswordFile = config.sops.secrets.aitvaras-password.path;
      extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
      shell = pkgs.fish;
    };
  };
}

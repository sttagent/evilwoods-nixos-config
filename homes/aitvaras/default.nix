{config, pkgs, ...}@args:
let 
  thisUser = "aitvaras";
in 
{
  imports = [
    ./home.nix
    ./nvim.nix
  ];
  
  config = {
    users.users = {
      ${thisUser} = {
        isNormalUser = true;
        description = "Arvydas Ramanauskas";
        hashedPassword = "$6$r5XosfFY6X0yH0kg$sPHtZm25ZWpsx86cdKUsjr8fMv6AU6Jmj26H9qBbRKVOJx5SUBw2sSIwXx5FxAvarWmukal0r7.Biy1wpClwd1";
        extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
        shell = pkgs.fish;
      };
    };
  };
}
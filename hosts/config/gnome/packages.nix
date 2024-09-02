{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ papers ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    evince
  ];

}

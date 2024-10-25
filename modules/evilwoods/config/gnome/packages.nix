{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnome-keyring
    dconf-editor
    papers
    showtime
    gnome-extension-manager
    dconf
    # valent
    pika-backup
  ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    evince
    totem
  ];

}

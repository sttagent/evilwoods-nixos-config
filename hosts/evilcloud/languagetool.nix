{ pkgs, lib, ... }: {
  services.languagetool = {
    enable = true;
    public = true;
    port = lib.mkDefault 8081;
    allowOrigin = "\"*\""; # To allow access from browser addons

  };
}

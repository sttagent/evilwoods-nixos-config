{config, pkgs, lig, ...}:

{
  config = {
    environment.systemPackages = with pkgs; [
      yubioauth-desktop
    ];
  };
}

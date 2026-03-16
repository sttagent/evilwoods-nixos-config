{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        extraPackages = with pkgs; [
          gamescope
        ];
      };
      hardware.steam-hardware.enable = true;
    };
}

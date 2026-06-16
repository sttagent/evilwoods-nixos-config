{
  den.aspects.gaming.steam = {
    nixos = { pkgs, ... }: {
      programs.steam = {
        enable = true;
        extraPackages = with pkgs; [
          gamescope
        ];
      };
      hardware.steam-hardware.enable = true;
    };
  };
}

{ den, ... }: {
  den.aspects.roles.desktop.umbriel = {
    includes = [ den.aspects.roles.desktop ];
    nixos = { pkgs, ... }: {
      programs.umbriel = {
        enable = true;
      };
      environment.systemPackages = with pkgs; [
        # noctalia-shell # old noctalia in nixpkgs
        xwayland-satellite
        adwaita-icon-theme
        adw-gtk3
        nautilus
      ];
    };
  };
}

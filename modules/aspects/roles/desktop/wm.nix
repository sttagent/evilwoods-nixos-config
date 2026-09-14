{ den, ... }: {
  den.aspects.roles.desktop.wm = { shell, wm }: {
    includes = [
      den.aspects.roles.desktop.${shell}
      den.aspects.roles.desktop.${wm}
    ];

    nixos = {
      services = {
        gnome.gnome-keyring.enable = false;
        oo7.enable = true;
        tuned.enable = true;
        udisks2.enable = true;
        gvfs.enable = true;
      };
    };
  };
}

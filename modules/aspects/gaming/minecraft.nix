{
  den.aspects.gaming.minecraft.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      (prismlauncher.override {
        jdks = [ jdk25 ];
      })
    ];
  };
}

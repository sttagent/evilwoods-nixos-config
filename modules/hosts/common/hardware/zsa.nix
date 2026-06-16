{
  den.aspects.hardware.zsa = {
    nixos = { pkgs, ... }: {
      hardware.keyboard.zsa.enable = true;

      environment.systemPackages = with pkgs; [
        wally-cli
        keymapp
      ];
    };
  };
}

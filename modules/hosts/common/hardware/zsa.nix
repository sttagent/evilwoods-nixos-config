# Config for moonlander keyboard.
{
  flake.modules.nixos.hardwareZSA =
    { pkgs, ... }:
    {
      hardware.keyboard.zsa.enable = true;

      environment.systemPackages = with pkgs; [
        wally-cli
        keymapp
      ];
    };
}

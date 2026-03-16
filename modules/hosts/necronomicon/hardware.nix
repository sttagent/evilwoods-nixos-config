{
  flake.modules.nixos.hostNecronomicon =
    { ... }:
    {
      nixpkgs.hostPlatform = "x86_64-linux";
    };
}

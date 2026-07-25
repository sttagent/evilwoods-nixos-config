{ inputs, ... }: {
  den.aspects.rynepc = {
    nixos = {
      services.flatpak.package = inputs.nixpkgs-2605.legacyPackages.x86_64-linux.flatpak;
    };
  };
}

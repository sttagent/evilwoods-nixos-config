{ inputs, ... }: {
  flake-file.inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

  den.aspects.optional.tools.determinate.nixos = { pkgs, ... }: {
    imports = [ inputs.determinate.nixosModules.default ];
    environment.systemPackages = [ pkgs.fh ];
  };
}

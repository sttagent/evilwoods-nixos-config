{ inputs, ... }: {
  flake-file.inputs.determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

  den.aspects.tools.determinate.nixos = { pkgs, ... }: {
    imports = [ inputs.determinate.nixosModules.default ];
    environment.systemPackages = [ pkgs.fh ];
  };
}

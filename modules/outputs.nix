{ self, den, ... }:
{
  den.schema.flake-system.includes = [ den.aspects.evilwoods-update ];
  den.aspects.evilwoods-update.packages = { pkgs, ... }: {
    evilwoods-update = pkgs.callPackage "${self.outPath}/pkgs/evilwoods-update/package.nix" { };
  };
}

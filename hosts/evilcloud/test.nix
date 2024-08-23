# The file is not imported by default

{ inputs, ... }:
let
  lib = inputs.nixpkgs-2405.legacyPackages."x86_64-linux".lib;
  pkgs = inputs.nixpkgs-2405.legacyPackages."x86_64-linux";
  evilib = inputs.self.lib;
in
{
  name = "Evilcloud host tests";
  node = {
    pkgsReadOnly = false;
    specialArgs = {
      inherit inputs evilib;
    };
  };
  nodes = {
    evilcloudtest = {
      imports = [
        ./default.nix
        ../../modules
      ];
      evilwoods.isTestEnv = true;
    };
  };

  interactive.nodes.evilcloudtest = {
    users.users.nixtest = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "nixtest";
      shell = pkgs.fish;
    };
  };

  testScript = ''
    evilcloudtest.wait_for_unit("default.target")
    evilcloudtest.succeed("systemctl is-active blocky")
    evilcloudtest.succeed("systemctl is-active caddy")
    evilcloudtest.succeed("systemctl is-active ntfy-sh")
  '';
}

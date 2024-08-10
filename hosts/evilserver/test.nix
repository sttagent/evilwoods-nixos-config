# The file is not imported by default

{ inputs, ... }:
let
  lib = inputs.nixpkgs-2405.legacyPackages."x86_64-linux".lib;
  pkgs = inputs.nixpkgs-2405.legacyPackages."x86_64-linux";
  evilib = inputs.self.lib;
in
{
  name = "Evilserver host tests";
  node = {
    pkgsReadOnly = false;
    specialArgs = { inherit inputs evilib; };
  };
  nodes = {
    evilservertest = {
      imports = [ ./default.nix ../../modules ];
      evilwoods.isTestEnv = true;
    };
  };

  interactive.nodes.evilservertest = {
    users.users.nixtest = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "nixtest";
      shell = pkgs.fish;
    };
  };

  testScript = ''
    evilservertestg.wait_for_unit("default.target")
    evilservertestg.succeed("systemctl is-active docker-kitchenowl-app")
    evilservertestg.succeed("systemctl is-active docker-languagetool-app")
    evilservertestg.succeed("systemctl is-active caddy")
  '';
}

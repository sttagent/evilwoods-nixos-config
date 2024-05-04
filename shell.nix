{
  pkgs ? (import ./nixpkgs.nix) { }, ...
}:
{
  default = pkgs.mkShell {
    name = "evilwoods-nixos-config";
    NIX_CONFIG = "experimental-features = nix-command flakes";
    nativeBuildInputs = with pkgs; [
      fish
      nix
      home-manager
      git
    ];
    shellHook = ''
      exec fish
    '';
  };
}

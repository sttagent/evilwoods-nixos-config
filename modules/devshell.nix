{ inputs, den, ... }:
{
  den.schema.flake-system.includes = [ den.aspects.nixos-devshell ];

  den.aspects.nixos-devshell =  {
    devShells = { pkgs, ... }: {
      default = pkgs.mkShell {
        name = "evilwoods-nixos-config";
        packages = with pkgs; [
          nixd
          nix-output-monitor
          nvd
          nixfmt
          jq
          # (python3.withPackages (
          #   ps: with ps; [
          #     questionary
          #     python-lsp-server
          #   ]
          # ))
          basedpyright
          ruff
          lua-language-server
          nixos-option
          nix-tree
          statix
        ];
      };
    };
  };
}

default:
    just --list

refresh:
    nix flake update --commit-lock-file
    
switch:
    nixos-rebuild switch --use-remote-sudo

boot:
    nixos-rebuild boot --use-remote-sudo

update:
    just refresh boot
    
diff:
    nix store diff-closures ./result /run/current-system
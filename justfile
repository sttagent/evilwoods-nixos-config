default:
    just --list

refresh:
    nix flake update --commit-lock-file
    
switch:
    nixos-rebuild switch --use-remote-sudo

boot:
    nixos-rebuild boot --use-remote-sudo

build:
    nixos-rebuild build |& nom

upgrade:
    just refresh boot
    
diff:
    nvd diff /run/current-system ./result/

format-disk host:
    nix run github:nix-community/disko -- --mode disko --flake .#{{host}}

gen-ssh-keys:
    mkdir -p /mnt/etc/ssh
    ssh-keygen -A -f /mnt
    just gen-age-key

gen-age-pub-key:
    ssh-to-age -i /mnt/etc/ssh/ssh_host_ed25519_key.pub

save-age-key:
    mkdir -p ~/.config/sops/age/
    touch ~/.config/sops/age/keys.txt
    bw get password evilwoods-nixos-sops | tee ~/.config/sops/age/keys.txt

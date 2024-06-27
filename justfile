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
    sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake .#{{host}}

gen-ssh-keys:
    sudo mkdir -p /mnt/etc/ssh
    sudo ssh-keygen -A -f /mnt

gen-age-pub-key host:
    #!/usr/bin/env bash
    age_pub_key=$(ssh-to-age -i /mnt/etc/ssh/ssh_host_ed25519_key.pub)
    sed "s/\(^ \+- &{{host}} \).*/\1$age_pub_key/" -i .sops.yaml
    sops updatekeys -y ./secrets/secrets.yaml

save-age-key username password:
    #!/usr/bin/env bash
    mkdir -p ~/.config/sops/age/
    touch ~/.config/sops/age/keys.txt
    session_key=$(bw login {{username}} {{password}} --raw)
    bw get password evilwoods-nixos-sops --session "$session_key" | tee ~/.config/sops/age/keys.txt

install-nixos host:
    sudo nixos-install --no-root-password --flake .#{{host}}

setup-nixos host username password:
    just config-env
    just format-disk {{host}}
    just gen-ssh-keys
    just save-age-key {{username}} {{password}}
    just gen-age-pub-key {{host}}
    just install-nixos {{host}}


config-env:
    #!/usr/bin/env bash
    echo | tee ~/.ssh/config <<- EndOfMessage
    Host *
        IdentitiesOnly yes
        IdentityAgent none
        IdentityFile ~/.ssh/id_ed25519_sk_rk_yubikey2
    EndOfMessage
    git config user.name "Arvydas Ramanauskas"
    git config user.email "711261+sttagent@users.noreply.github.com"

# Evilwoods NixOS Config

This is my personal very much work in progress NixOS configuration.

Hosts:

- `evilbook` - laptop
- `evilserver` - home server
- `evilcloud` - server (currently not used)

## Notes

### Installation notes

- clone repo with custom ssh command.

```bash
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_sk_rk_yubikey2 -o IdentityAgent=none" \
git clone git@github.com:sttagent/evilwoods-nixos-config.gita && \
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_sk_rk_yubikey2 -o IdentityAgent=none" \
git clone git@github.com:sttagent/evilwoods-nixos-config-secrets.git
```

- Setup host ssh keys.
  - Generate new ones with the script in secrets repo or point to old ones
  - Update re-encrypt sops secrets
- Install nixos using the script in the config repo

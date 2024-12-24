# Evilwoods NixOS Config

This is my personal very much work in progress NixOS configuration.

Hosts:

- `evilbook` - laptop
- `evilserver` - home server
- `evilcloud` - server (currently not used)

## Notes

### Installation notes
- clone repo with custom ssh command.
```
GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ssh_key -o IdentityAgent=none" git clone
```
- Setup host ssh keys.
  - Generate new ones with the script in secrets repo or point to old ones
  - Update re-encrypt sops secrets
- Install nixos using the script in the config repo

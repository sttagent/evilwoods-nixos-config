{ inputs, ... }:
{
  flake.modules.nixos.hostEvilbook =
    { config, ... }:
    let
      serviceName = "evilbook-aitvaras";
      repoName = "restic-backups-${serviceName}";
      repository = "/var/storage/shares/smb/backups/${repoName}";
      user = config.evilwoods.variables.mainUser;
      userHome = "/home/${user}";
      sopsFile = "${inputs.evilsecrets}/secrets/${user}/default.yaml";
      secretName = "${repoName}-repo-pass";
      passwordFile = config.sops.secrets."${secretName}".path;
    in
    {
      sops.secrets."${secretName}" = {
        inherit sopsFile;
        owner = user;
        group = "users";
        mode = "0400";
      };
      services.restic.backups.${serviceName} = {
        inherit user repository passwordFile;
        initialize = false;
        inhibitsSleep = true;
        paths = [
          userHome
        ];
        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
          "--keep-yearly 5"
        ];
        timerConfig = {
          OnCalendar = "21:00";
          Persistent = true;
        };
        exclude = [
          "${userHome}/.cache"
          "${userHome}/.mozilla"

          # Downloads
          "${userHome}/Downloads"

          # Flatpak
          "${userHome}/.local/share/flatpak"

          # Trash & thumbnails
          "${userHome}/.local/share/Trash"
          "${userHome}/.local/share/thumbnails"

          # VM disks (GNOME Boxes, libvirt/virt-manager, VirtualBox, Vagrant)
          "${userHome}/.local/share/gnome-boxes"
          "${userHome}/.local/share/libvirt"
          "${userHome}/VirtualBox VMs"
          "${userHome}/.vagrant.d/boxes"

          # Container images (Podman, Docker)
          "${userHome}/.local/share/containers"
          "${userHome}/.docker"

          # Steam / games
          "${userHome}/.local/share/Steam"
          "${userHome}/.steam"

          # Development caches (Cargo, npm, Gradle, Maven)
          "${userHome}/.cargo/registry"
          "${userHome}/.cargo/git"
          "${userHome}/.npm"
          "${userHome}/.gradle"
          "${userHome}/.m2"

          # VM disk image file extensions (anywhere under home)
          "*.vmdk"
          "*.qcow2"
          "*.vdi"
          "*.vhd"
          "*.vhdx"
          "*.iso"
        ];
      };
      systemd.services."${repoName}" = {
      };
    };
}

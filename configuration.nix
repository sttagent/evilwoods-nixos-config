{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  # Additional filesystem options
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };


  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot.enable = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
    kernelParams = [
      "quiet"
      "slash"
      "rd.systemd.show_status=false"
    ];
  };


  hardware = {
    # Enable moonlander keyboard udev rules

    nvidia =  {
      # Required for wayland
      modesetting.enable = true;
      powerManagement.enable = true;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

  };


  # disable user creation. needed to disable root account
  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    root.hashedPassword = "!";

    aitvaras = {
      isNormalUser = true;
      hashedPassword = "$6$r5XosfFY6X0yH0kg$sPHtZm25ZWpsx86cdKUsjr8fMv6AU6Jmj26H9qBbRKVOJx5SUBw2sSIwXx5FxAvarWmukal0r7.Biy1wpClwd1";
      extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    };
  };


  virtualisation = {
    podman = {
      enable = true;
      enableNvidia = true;
    };
  };
}


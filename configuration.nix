{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  nix = {
    package = pkgs.nixFlakes;
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


  zramSwap.enable = true;

  
  networking = {
    hostName = "evilroots"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    firewall = {
      # Open ports in the firewall.
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # enable = false;
    };
  };


  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "sv_SE.UTF-8";
      LC_IDENTIFICATION = "sv_SE.UTF-8";
      LC_MEASUREMENT = "sv_SE.UTF-8";
      LC_MONETARY = "sv_SE.UTF-8";
      LC_NAME = "sv_SE.UTF-8";
      LC_NUMERIC = "sv_SE.UTF-8";
      LC_PAPER = "sv_SE.UTF-8";
      LC_TELEPHONE = "sv_SE.UTF-8";
      LC_TIME = "sv_SE.UTF-8";
    };
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };


  hardware = {
    # Enable moonlander keyboard udev rules
    keyboard.zsa.enable = true;

    nvidia =  {
      # Required for wayland
      modesetting.enable = true;
      powerManagement.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    # Needs to be disabled if using pipwire
    pulseaudio.enable = false;
  };


  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable the X11 windowing system.
    xserver = {
      # Configure keymap in X11
      # layout = "us";
      # xkbOptions = {
      #   "eurosign:e";
      #   "caps:escape" # map caps to escape.
      # };

      enable = true;
      videoDrivers = [ "nvidia" ];

      # Enable the GNOME Desktop Environment.
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
    };

    # enable pipwire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    flatpak.enable = true;

    # Enable CUPS to print documents
    # printing.enable = true;
  };


  # Recommended for pipwire
  security.rtkit.enable = true;


  # disable user creation. needed to disable root account
  users.mutableUsers = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    root.hashedPassword = "!";

    aitvaras = {
      isNormalUser = true;
      hashedPassword = "$6$r5XosfFY6X0yH0kg$sPHtZm25ZWpsx86cdKUsjr8fMv6AU6Jmj26H9qBbRKVOJx5SUBw2sSIwXx5FxAvarWmukal0r7.Biy1wpClwd1";
      extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
      packages = with pkgs; [
        bottles
	gnomeExtensions.appindicator
	element-desktop
	discord
	standardnotes
	wally-cli
      ];
    };
  };


  # allow propriety software
  nixpkgs.config.allowUnfree = true;


  # Set your time zone.
  time.timeZone = "Europe/Stockholm";


  environment = {
    # List packages installed in system profile. To search, run:
    systemPackages = with pkgs; [
      neovim
      firefox
      wget
      tmux
      nushell
      git
      git-crypt
      htop
      gnupg
    ];

    variables = {
      MOZ_ENABLE_WAYLAND = "1";
      EDITOR = "nvim";
    };

    gnome.excludePackages = with pkgs; [
      epiphany
    ];
  };


  programs = {
    steam.enable = true;

    xwayland.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  virtualisation = {
    podman = {
      enable = true;
      enableNvidia = true;
    };
  };


  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}


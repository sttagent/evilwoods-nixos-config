{ inputs, ... }:
{
  flake.modules.nixos."userAitvaras@evilbook" =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (lib) mkIf;
      inherit (config.evilwoods.variables) desktopEnvironment;
      inherit (pkgs.stdenv.hostPlatform) system;
      currentUser = "aitvaras";
      noctalia-pkg = inputs.noctalia.packages.${system}.default;
      noctalia-shell-bin = "${noctalia-pkg}/bin/noctalia-shell";

      dotFilesPath = inputs.self.outPath + "/dotfiles";
    in
    {
      config = mkIf (desktopEnvironment == "niri") {
        home-manager.users.${currentUser} = {
          # import the home manager module
          imports = [
            inputs.noctalia.homeModules.default
          ];

          dconf.settings = {
            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              gtk-theme = "Adwaita-dark";
              accent-color = "green";
            };
          };

          # configure options
          programs = {
            noctalia-shell = {

              enable = true;
              settings = {
                # configure noctalia here
                settingsVersion = 0;
                notifications = {
                  location = "top";
                };
                bar = {
                  barType = "floating";
                  floating = true;
                  density = "default";
                  position = "top";
                  showCapsule = false;
                  widgets = {
                    left = [
                      {
                        hideUnoccupied = false;
                        id = "Workspace";
                        labelMode = "index";
                      }
                      {
                        id = "ActiveWindow";
                      }
                    ];
                    center = [
                      {
                        formatHorizontal = "HH:mm";
                        formatVertical = "HH mm";
                        id = "Clock";
                        useMonospacedFont = true;
                        usePrimaryColor = true;
                      }
                      {
                        id = "NotificationHistory";
                      }
                    ];
                    right = [
                      {
                        id = "Tray";
                      }
                      {
                        id = "plugin:privacy-indicator";
                        defaultSettings = {
                          hideInactive = true;
                        };
                      }
                      {
                        id = "plugin:kde-connect";
                        displayMode = "alwaysHide";
                      }
                      {
                        id = "KeyboardLayout";
                        displayMode = "forceOpen";
                      }
                      {
                        id = "Volume";
                        displayMode = "alwaysHide";
                      }
                      {
                        id = "WiFi";
                        displayMode = "alwaysHide";
                      }
                      {
                        id = "Bluetooth";
                        displayMode = "alwaysHide";
                      }
                      {
                        alwaysShowPercentage = false;
                        id = "Battery";
                        warningThreshold = 30;
                      }
                      {
                        id = "ControlCenter";
                        useDistroLogo = true;
                      }
                    ];
                  };
                };
                dock = {
                  showDockIndicator = true;
                };
                colorSchemes.predefinedScheme = "Miasma";
                general = {
                  # radiusRatio = 0.2;
                  lockScreenBlur = 0.8;
                };
                location = {
                  monthBeforeDay = true;
                  firstDayOfWeek = 1;
                  showWeekNumberInCalendar = true;
                  name = "Skellefteå, Sweden";
                };

                ui = {
                  fontDefault = "Adwaita Sans";
                  fontFixed = "Adwaita Mono";
                };
                wallpaper = {
                  overviewEnabled = true;
                  overviewBlur = 0.8;
                };
                audio = {
                  volumeFeedback = true;
                };
                controlCenter = {
                  cards = [
                    {
                      enabled = true;
                      id = "profile-card";
                    }
                    {
                      enabled = true;
                      id = "shortcuts-card";
                    }
                    {
                      enabled = true;
                      id = "audio-card";
                    }
                    {
                      enabled = true;
                      id = "brightness-card";
                    }
                    {
                      id = "weather-card";
                      enabled = false;
                    }
                    {
                      id = "media-sysmon-card";
                      enabled = false;
                    }
                  ];
                };
                idle = {
                  customCommands = [ ];
                  enabled = true;
                  fadeDuration = 5;
                  lockTimeout = 320;
                  screenOffTimeout = 300;
                  suspendTimeout = 1800;
                };
              };
              plugins = {
                sources = [
                  {
                    enabled = true;
                    name = "Noctalia Plugins";
                    url = "https://github.com/noctalia-dev/noctalia-plugins";
                  }
                ];
                states = {
                  kde-connect = {
                    enabled = true;
                    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
                  };
                  privacy-indicator = {
                    enabled = true;
                    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
                  };
                  polkit-agent = {
                    enabled = true;
                    sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
                  };
                };
                version = 2;
              };
            };
          };
          services = {
            kanshi = {
              enable = true;
              settings = [
                {
                  profile = {
                    name = "laptop-only";
                    outputs = [
                      {
                        criteria = "eDP-1";
                        mode = "1920x1080@60.042";
                        scale = 1.25;
                        transform = "normal";
                      }
                    ];
                    exec = [
                      "${noctalia-shell-bin} ipc call bar setDisplayMode always_visible eDP-1"
                    ];
                  };
                }
                {
                  profile = {
                    name = "external-monitor";
                    outputs = [
                      {
                        criteria = "eDP-1";
                        mode = "1920x1080@60.042";
                        transform = "normal";
                      }
                      {
                        criteria = "*C32JG5x*";
                        mode = "2560x1440@99.946";
                        adaptiveSync = true;
                        position = "2560,-420";
                      }
                    ];
                    exec = [
                      "${noctalia-shell-bin} ipc call bar setDisplayMode auto_hide eDP-1"
                    ];
                  };
                }
              ];
            };
          };

          xdg.configFile."niri/config.kdl" = {
            source = dotFilesPath + "/niri/config.kdl";
          };
        };
      };
    };
}

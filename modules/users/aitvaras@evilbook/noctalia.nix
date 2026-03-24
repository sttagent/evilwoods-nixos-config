{ inputs, ... }:
{
  flake.modules.nixos."userAitvaras@evilbook" =
    {
      lib,
      config,
      ...
    }:
    let
      inherit (lib) mkIf;
      inherit (config.evilwoods.variables) desktopEnvironment;
      currentUser = "aitvaras";
      resourceDir = inputs.self.outPath + "/resources";
      wallpaperPath = resourceDir + "/wallpapers/background.jpg";
    in
    {
      config = mkIf (desktopEnvironment == "niri") {
        home-manager.users.${currentUser} = {
          # import the home manager module
          imports = [
            inputs.noctalia.homeModules.default
          ];
          # xdg.autostart.entries = [ ];
          xdg.cacheFile."noctalia/wallpapers.json" = {
            enable = true;
            text = builtins.toJSON {
              defaultWallpaper = wallpaperPath;
              wallpapers = {
                "HDMI-A-1" = wallpaperPath;
                "eDP-1" = wallpaperPath;
              };
            };
          };
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
                        pinned = [
                          "Discord"
                        ];
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
                  pinnedStatic = true;
                  inactiveIndicators = true;
                  pinned-apps = [
                    "vivaldi-stable"
                    "com.mitchellh.ghostty"
                  ];
                };
                colorSchemes.predefinedScheme = "Miasma";
                general = {
                  # radiusRatio = 0.2;
                  lockScreenBlur = 0.8;
                  shadowDirection = "bottom";
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
        };
      };
    };
}

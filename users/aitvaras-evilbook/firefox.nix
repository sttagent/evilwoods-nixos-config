currentUser:
{ pkgs, ... }:
{
  home-manager.users.${currentUser} = {
    programs = {
      firefox = {
        enable = true;
        nativeMessagingHosts = [ pkgs.tridactyl-native ];
        profiles."${currentUser}" = {
          name = "${currentUser}";
          id = 0;
          isDefault = true;
          search = {
            force = true;
            default = "Evilwoods";
            order = [
              "Evilwoods"
              "google"
            ];
            engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "NixOS Wiki" = {
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                icon = "https://wiki.nixos.org/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000; # every day
                definedAliases = [ "@nw" ];
              };

              "Evilwoods" = {
                urls = [ { template = "https://search.evilwoods.net/search?q={searchTerms}"; } ];
                definedAliases = [ "@ew" ];
              };

              bing.metaData.hidden = true;
              google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias
            };
          };
          settings = {
            "browser.startup.homepage" = "https://search.evilwoods.net/";
            "browser.search.defaultenginename" = "Evilwoods";
            "browser.contentblocking.category" = "strict";
            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;
            "widget.dmabuf.force-enabled" = true;
          };
        };
      };
    };
  };
}

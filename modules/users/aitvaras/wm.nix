{ den, ... }: {
  den.aspects.aitvaras.wm = {
    homeManager =
      { lib, pkgs, ... }:
      let
        noctalia-exec = lib.getExe pkgs.noctalia;
      in
      {
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
                      position = "0,0";
                    }
                  ];
                  exec = [
                    "${noctalia-exec} msg bar-show default eDP-1"
                  ];
                };
              }
              {
                profile = {
                  name = "external-monitor";
                  outputs = [
                    {
                      criteria = "*C32JG5x*";
                      mode = "2560x1440@99.946";
                      adaptiveSync = true;
                      position = "0,0";
                    }
                    {
                      criteria = "eDP-1";
                      mode = "1920x1080@60.042";
                      transform = "normal";
                      position = "2560,440";
                    }
                  ];
                  exec = [
                    "${noctalia-exec} msg bar-hide default eDP-1"
                  ];
                };
              }
            ];
          };
        };
      };
  };

  den.aspects.aitvaras = {
    includes = [
      (den.lib.aspects.fx.includes.includeIf ({ host, ... }: host.hasAspect den.aspects.roles.desktop.wm)
        [
          den.aspects.aitvaras.wm
        ]
      )
    ];
  };
}

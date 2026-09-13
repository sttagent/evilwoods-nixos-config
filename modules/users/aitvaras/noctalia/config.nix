{ den, ... }: {

  den.aspects.aitvaras = {
    includes = [
      (den.lib.aspects.fx.includes.includeIf
        ({ host, ... }: host.hasAspect den.aspects.roles.desktop.noctalia)
        [
          den.aspects.aitvaras.noctalia
        ]
      )
    ];
  };
}

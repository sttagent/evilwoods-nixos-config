{ den, ... }: {

  den.aspects.aitvaras = {
    includes = [
      (den.lib.policy.when (
        { host, ... }: host.hasAspect den.aspects.desktop.niri
      ) den.aspects.aitvaras.niri)
    ];
  };
}

{ den, ... }: {

  den.aspects.aitvaras = {
    includes = [
      (den.lib.policy.when ({ host, ... }: host.hasAspect den.aspects.desktop.niri) (
        den.lib.policy.include den.aspects.aitvaras.niri
      ))
    ];
  };
}

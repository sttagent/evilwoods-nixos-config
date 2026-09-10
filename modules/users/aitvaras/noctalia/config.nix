{ den, ... }: {

  den.aspects.aitvaras = {
    includes = [
      (den.lib.policy.when ({ host, ... }: host.hasAspect den.aspects.desktop-environment.noctalia) (
        den.lib.policy.include den.aspects.aitvaras.noctalia
      ))
    ];
  };
}

{ den, ... }: {

  den.aspects.aitvaras = {
    includes = [
      (den.lib.policy.when ({ host, ... }: host.hasAspect den.aspects.role.desktop.noctalia) (
        den.lib.policy.include den.aspects.aitvaras.noctalia
      ))
      # (den.lib.policy.when ({ host, user, ... }: host.hasAspect den.aspects.role.desktop.niri) {
      #   nixos = { pkgs, ... }: { environment.systemPackages = [ pkgs.pika-backup ]; };
      # })
    ];
  };
}

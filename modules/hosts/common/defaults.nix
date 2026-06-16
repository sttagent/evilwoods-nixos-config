{ den, ... }: {
  den.schema.host = {
    home-manager.enable = true;
    includes = [
      den.aspects.hostBase
    ];
  };
}

{
  den.aspects.ryne.homeManager =
    { host, pkgs, ... }:
    {
      home.stateVersion = host.stateVersion;
    };
}

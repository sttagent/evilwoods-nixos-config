{
  den.aspects.admin.homeManager =
    { host, pkgs, ... }:
    {
      home.stateVersion = host.stateVersion;
    };
}

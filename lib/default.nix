rec {
  defaultSystem = "x86_64-linux";

  mkPkgs = { channel, system ? defaultSystem, cfg ? { allowUnfree = true; } }:
    import channel {
      inherit system;
      config = cfg;
    };
}

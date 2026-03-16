{ self, ... }:
{
  flake.modules.nixos."userAdmin@necronomicon" =
    { ... }:
    {
      imports = [ self.modules.nixos.userAdmin ];
    };
}

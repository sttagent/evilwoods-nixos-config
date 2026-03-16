{ self, ... }:
{
  flake.modules.nixos."userRyne@necronomicon" =
    { ... }:
    {
      imports = [ self.modules.nixos.userRyne ];
    };
}

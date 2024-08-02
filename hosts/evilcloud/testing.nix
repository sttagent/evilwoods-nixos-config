{ config, lib, ... }:{
  specialisation.test.configuration = {
    networking.hostName = lib.mkForce "${config.networking.hostName}-testing";
  };
}
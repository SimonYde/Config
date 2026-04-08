{ lib, ... }:
{
  system.stateVersion = "25.11";

  systemd.oomd.enable = lib.mkForce true;
  services.syncthing.enable = true;
}

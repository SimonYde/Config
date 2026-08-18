{ lib, pkgs, ... }:
{
  system.stateVersion = "25.11";

  systemd.oomd.enable = lib.mkForce true;
  services.syncthing.enable = true;

  fonts.packages = with pkgs; [
    source-sans
    roboto
    font-awesome_7
  ];
}

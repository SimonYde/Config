{ pkgs, ... }:

{
  services.kdeconnect = {
    package = pkgs.kdePackages.kdeconnect-kde;
    indicator = true;
  };
}

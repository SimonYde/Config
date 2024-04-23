{ pkgs, ... }:
{
  programs.kdeconnect = {
    package = pkgs.kdePackages.kdeconnect-kde;
  };
}

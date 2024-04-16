{ pkgs, ... }:

{
  programs.kdeconnect = {
    package = pkgs.kdePackages.kdeconnect-kde;
  };
  networking.firewall = rec { # Required for KDE Connect to work
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
}

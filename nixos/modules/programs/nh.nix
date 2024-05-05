{ config, ... }:
{
  programs.nh = {
    flake = "/home/${config.syde.user}/Config";
    clean = {
      enable = true;
      extraArgs = "--keep 3 --keep-since 4d";
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.gammastep = {
    temperature = {
      day = 6500;
      night = 2200;
    };
    tray = true;
    duskTime = "18:45-21:00";
    dawnTime = "6:00-7:45";
    provider = "manual";
    latitude = 56.3;
    longitude = 9.5;
  };

  xdg.configFile."gammastep/hooks/notify" = {
    inherit (config.services.gammastep) enable;
    executable = true;
    text = # bash
      ''
        #!/usr/bin/env bash
        case $1 in
            period-changed)
                exec ${lib.getExe' pkgs.libnotify "libnotify"} "Gammastep" "Period changed to $3"
        esac
      '';
  };
}

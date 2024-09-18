{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gammastep;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ libnotify ];
    services.gammastep = {
      temperature = {
        day = 6500;
        # night = 1900;
        night = 2200;
      };
      tray = true;
      duskTime = "18:45-20:30";
      dawnTime = "6:00-7:45";
      provider = "manual";
      latitude = 56.3;
      longitude = 9.5;
      settings = {
        general = {
          # adjustment-method = "drm";
          # fade = 1;
        };
      };
    };

    xdg.configFile."gammastep/hooks/notify" = {
      text = # bash
        ''
        #!/usr/bin/env bash
        case $1 in
            period-changed)
                exec notify-send "Gammastep" "Period changed to $3"
        esac
      '';
      executable = true;
    };
  };
}

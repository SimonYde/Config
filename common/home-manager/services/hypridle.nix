{
  config,
  lib,
  ...
}:

let
  cfg = config.services.hypridle;
in
{
  config = lib.mkIf cfg.enable {
    services.hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = 360;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}

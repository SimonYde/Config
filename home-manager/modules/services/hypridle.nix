{ config, lib, pkgs, ... }:

let
  cfg = config.services.hypridle;
  lock = config.syde.gui.lock;
in
{
  config = lib.mkIf cfg.enable {
    services.hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
          lock_cmd = lock;
        };
        listener = [
          {
            timeout = 180;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl s 63";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl s 255";
          }
          {
            timeout = 360;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 900;
            on-timeout = "systemctl suspend";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}

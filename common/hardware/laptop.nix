{
  lib,
  pkgs,
  username,
  config,
  ...
}:
let
  inherit (lib) getExe mkDefault mkIf;

  cfg = config.syde.hardware.laptop;
in
{
  options.syde.hardware.laptop = {
    enable = lib.mkEnableOption "laptop configuration";
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth = {
        enable = mkDefault true;
        powerOnBoot = mkDefault false;
      };

      nvidia = {
        powerManagement.enable = true;
        powerManagement.finegrained = true;
      };
    };

    home-manager.users.${username} = {
      services.hypridle.settings.listener =
        let
          brightnessctl = getExe pkgs.brightnessctl;
        in
        [
          # Turn off keyboard backlight on idle.
          {
            timeout = 60;
            on-timeout = "${brightnessctl} -sd *::kbd_backlight set 0";
            on-resume = "${brightnessctl} -rd *::kbd_backlight";
          }

          # Dim display after a few minutes.
          {
            timeout = 180;
            on-timeout = "${brightnessctl} -s s 50%-";
            on-resume = "${brightnessctl} -r";
          }

          # Lock session after a while longer.
          {
            timeout = 360;
            on-timeout = "loginctl lock-session";
            on-resume = "";
          }

          # Sleep laptop.
          {
            timeout = 900;
            on-timeout = "systemctl suspend";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
    };
  };
}

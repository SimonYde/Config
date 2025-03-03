{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) getExe mkDefault;
  inherit (config.syde) user;
in
{
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

  home-manager.users.${user} = {
    services.hypridle.settings.listener =
      let
        brightnessctl = getExe pkgs.brightnessctl;
      in
      [
        {
          timeout = 180;
          on-timeout = "${brightnessctl} -s s 50%-";
          on-resume = "${brightnessctl} -r";
        }
        {
          timeout = 360;
          on-timeout = "loginctl lock-session";
          on-resume = "";
        }
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
      ];
  };
}

{ pkgs, lib, ... }:
{
  config = {
    # Personal modules
    syde = {
      email.enable = false;
      gui.enable = true;
      programming.enable = true;
      ssh.enable = true;
      terminal.enable = true;
      desktop.cosmic.enable = false;
      theming.enable = true;
    };

    home.packages = with pkgs; [
      brightnessctl
    ];

    # TODO: laptop module?
    services.hypridle = {
      settings = {
        listener = [
          {
            timeout = 60;
            # NOTE: name of device is specific for this device
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd platform::kbd_backlight set 0";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd platform::kbd_backlight";
          }
          {
            timeout = 180;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s s 50%-";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
          }
          {
            timeout = 360;
            on-timeout = "loginctl lock-session";
            on-resume = "";
          }
          {
            timeout = 900;
            on-timeout = "systemctl suspend";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        general.allow_tearing = lib.mkForce false; # NOTE: freezes and doesn't tear
      };
    };
  };

  imports = [ ../standard.nix ];
}

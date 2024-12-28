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
      extraConfig = # hyprlang
        ''
          workspace=1, monitor:e-DP-1, default:true
          workspace=2, monitor:e-DP-1
          workspace=3, monitor:e-DP-1
          workspace=4, monitor:e-DP-1
          workspace=5, monitor:e-DP-1
          workspace=6, monitor:e-DP-1
          workspace=7, monitor:e-DP-1
          workspace=8, monitor:e-DP-1

          workspace=9, monitor:HDMI-A-1,  default:true
          workspace=10, monitor:HDMI-A-1
        '';
    };
  };

  imports = [ ../standard.nix ];
}

{ pkgs, ... }:
{
  config = {
    # Personal modules
    syde = {
      email.enable = false;
      gui.enable = true;
      programming.enable = true;
      ssh.enable = true;
      terminal.enable = true;
      desktop.cosmic.enable = true;
      theming.enable = true;
    };

    services.hypridle = {
      settings = {
        listener = [
          {
            timeout = 60;
            # NOTE: name of device is specific for this device
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -sd platform::kbd_backlight set 0";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -rd platform::kbd_backlight";
          }
        ];
      };
    };

    wayland.windowManager.hyprland = {
      enable = false;
      extraConfig = # hyprlang
        ''
          source = ~/.config/hypr/devices.conf
          source = ~/.config/hypr/monitors.conf
          source = ~/.config/hypr/keybindings.conf
          source = ~/.config/hypr/windowrules.conf

          # workspace=1, monitor:HDMI-A-1, default:true
          # workspace=2, monitor:HDMI-A-1
          # workspace=3, monitor:HDMI-A-1
          # workspace=4, monitor:HDMI-A-1
          # workspace=5, monitor:HDMI-A-1
          # workspace=6, monitor:HDMI-A-1
          #
          # workspace=7, monitor:e-DP-1
          # workspace=8, monitor:e-DP-1
          # workspace=9, monitor:e-DP-1
          # workspace=10, monitor:e-DP-1
        '';
    };
  };

  imports = [ ../standard.nix ];
}

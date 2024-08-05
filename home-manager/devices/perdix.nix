{ lib, pkgs, ... }@args:
{
  config = {
    # Personal modules
    syde = {
      email.enable = false;
      gui.enable = true;
      programming.enable = true;
      ssh.enable = true;
      terminal.enable = true;
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

    wayland.windowManager =
      {
        sway.enable = false;
        hyprland.enable = false;
      }
      # NOTE: This is more of a tests than anything else.
      // lib.optionalAttrs (args ? "osConfig") {
        sway.enable = args.osConfig.programs.sway.enable;
        hyprland.enable = args.osConfig.programs.hyprland.enable;
      };
  };

  imports = [ ../standard.nix ];
}

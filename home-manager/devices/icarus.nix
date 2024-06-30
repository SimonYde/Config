{ config, lib, ... }@args:
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

    wayland.windowManager =
      {
        sway.enable = false;
        hyprland.enable = true;
      }
      # NOTE: This is more of a tests than anything else.
      // lib.optionalAttrs (args ? "osConfig") {
        sway.enable = args.osConfig.programs.sway.enable;
        hyprland.enable = args.osConfig.programs.hyprland.enable;
      };
  };

  imports = [ ../standard.nix ];
}

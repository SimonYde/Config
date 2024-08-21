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

    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = # hyprlang
        ''
          source = ~/.config/hypr/devices.conf
          source = ~/.config/hypr/monitors.conf
          source = ~/.config/hypr/keybindings.conf
          source = ~/.config/hypr/windowrules.conf

          workspace=1, monitor:DP-1, default:true
          workspace=2, monitor:DP-1
          workspace=3, monitor:DP-1
          workspace=4, monitor:DP-1
          workspace=5, monitor:DP-1
          workspace=6, monitor:DP-1

          workspace=7, monitor:HDMI-A-1, default:true
          workspace=8, monitor:HDMI-A-1
          workspace=9, monitor:DP-3, default:true
          workspace=10, monitor:DP-3
        '';
    };
  };

  imports = [ ../standard.nix ];
}

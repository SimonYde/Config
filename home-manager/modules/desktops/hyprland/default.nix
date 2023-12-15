{ lib, pkgs, config, inputs, ... }:

let
  cfg = config.wayland.windowManager.hyprland;
  terminal = config.syde.terminal;
  browser = config.syde.browser;
  menu = "rofi -show drun";
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      swaylock.enable = true;
      rofi.enable = true;
      waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "hyprland-session.target";
        };
      };
    };

    wayland.windowManager.hyprland = {
      package = null;
      extraConfig = ''
        monitor = eDP-1, 1920x1080, auto, 1
        input {
          kb_layout = us
          kb_variant = colemak_dh
          kb_options = caps:escape
          follow_mouse = 2
          touchpad {
            natural_scroll = yes
          }
        }
        $browser = ${browser}
        $menu = ${menu}
        $terminal = ${terminal.emulator}
        $filemanager = ${pkgs.xfce.thunar}/bin/thunar

        general {
          gaps_in = 3
          gaps_out = 8
          border_size = 2
          col.active_border = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
          col.inactive_border = rgba(b4befecc) rgba(6c7086cc) 45deg
          layout = dwindle
          resize_on_border = true
          gaps_in = 3
          gaps_out = 8
        }

        decoration {
          rounding = 10
          blur {
            enabled = true
            size = 6
            passes = 2
            new_optimizations = on
            ignore_opacity = on
            xray = false
          }

          drop_shadow = false
        }

        exec-once = nm-applet
        exec-once = blueman-applet
        exec-once = swww init
        exec-once = [workspace 1] obsidian
      '' +
      builtins.readFile ./keybindings.conf +
      builtins.readFile ./windowrules.conf +
      builtins.readFile ./animations.conf;
    };

    home.packages = with pkgs; [
      swww
      playerctl
      networkmanagerapplet
      pamixer
    ];
  };

  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
}

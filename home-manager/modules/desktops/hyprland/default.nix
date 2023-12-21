{ lib, pkgs, config, inputs, ... }:

let
  cfg = config.wayland.windowManager.hyprland;
  colors = config.colorScheme.colors;
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

    services.dunst.enable = true;

    wayland.windowManager.hyprland = {
      settings = {
        general = with colors; {
          gaps_in = 3;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = "rgba(${base07}ff) rgba(${base0E}ff) 45deg";
          "col.inactive_border" = "transparent"; # "rgba(${base00}d9)";
          layout = "dwindle";
          resize_on_border = true;
        };
        input = {
          kb_layout = "us";
          kb_variant = "colemak_dh";
          kb_options = "caps:escape,grp:rctrl_toggle";
          follow_mouse = 2;
          touchpad = {
            natural_scroll = true;
          };
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
          };
          drop_shadow = false;
        };

        animations = {
          enabled = true;
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 3, wind, slide"
            "windowsIn, 1, 3, winIn, slide"
            "windowsOut, 1, 2, winOut, slide"
            "windowsMove, 1, 2, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 7, default"
            "workspaces, 1, 4, wind"
          ];
        };

        monitor = "eDP-1, 1920x1080, auto, 1";
        "$browser" = browser;
        "$menu" = menu;
        "$terminal" = terminal.emulator;
        "$filemanager" = "thunar";

        exec-once = [
          "nm-applet"
          "blueman-applet"
          "swww init"
          "[workspace 1] obsidian"
        ];
      };
      extraConfig = with builtins;
        readFile ./keybindings.conf +
        readFile ./windowrules.conf;
    };

    home.packages = with pkgs; [
      swww
      playerctl
      networkmanagerapplet
      pamixer

      pavucontrol
      xfce.thunar

      grimblast
    ];
  };

  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
}

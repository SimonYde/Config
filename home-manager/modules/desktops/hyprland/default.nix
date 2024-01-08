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

    services = {
      dunst.enable = true;
      # network-manager-applet.enable = true;
      # blueman-applet.enable = true;
    };

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
          allow_tearing = true; # For gaming. Set windowrule `immediate` for games to enable.
        };

        "device:msft0001:00-06cb:ce2d-touchpad" = {
          accel_profile = "adaptive";
        };

        "device:zsa-technology-labs-moonlander-mark-i" = {
          kb_layout = "us";
        };
        # "device:zsa-technology-labs-moonlander-mark-i-keyboard" = {
        #   kb_layout = "us";
        # };
        input = {
          kb_layout = "us(colemak_dh),dk";
          kb_options = "caps:escape,grp:rctrl_toggle";
          follow_mouse = 2;
          accel_profile = "flat";
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

        monitor = [
          "eDP-1, 1920x1080, 0x0, 1"
          "desc:Ancor Communications Inc VG248 FBLMQS053462, 1920x1080@119.982002, 0x1080, 1"
        ];

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
      swww # wallpaper manager
      playerctl # media keys
      pamixer # volume keys
      networkmanagerapplet

      pavucontrol # audio control

      xfce.thunar # file manager
      grimblast # screenshot tool
      wl-clipboard # clipboard manager
      hyprpicker # color picker
      imv # image viewer
      mpv # Video player
    ];
  };

  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
}

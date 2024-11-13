{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  palette = config.colorScheme.palette;
  hyprland-gamemode = pkgs.callPackage ./gamemode.nix { };
  terminal = config.syde.terminal;
  browser = config.syde.gui.browser;
  file-manager = config.syde.gui.file-manager;
  lock = config.syde.gui.lock;
  menu = "${pkgs.rofi-wayland}/bin/rofi -show drun";
  cfg = config.wayland.windowManager.hyprland;
in
{
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprland-gamemode # disable hyprland animations for games
      playerctl # media keys
      pamixer # volume keys
      networkmanagerapplet

      pavucontrol # audio control
      hyprsunset # blue-light filter

      grimblast # screenshot tool
      wl-clipboard # clipboard manager
      hyprpicker # color picker
    ];

    # home.sessionVariables.NIXOS_OZONE_WL = 1;

    programs = {
      imv.enable = true;
      mpv.enable = true;
      rofi.enable = true;
      swaylock.enable = false;
      wlogout.enable = true;
      hyprlock.enable = true;
      waybar.enable = true;
    };

    syde.services = {
      hyprland-autoname-workspaces.enable = true;
      hyprsunset.enable = true;
      swww.enable = true;
    };

    services = {
      dunst.enable = false;
      hypridle.enable = true;
      swaync.enable = true;
    };


    wayland.windowManager.hyprland = {
      settings = {
        "$browser" = browser;
        "$file-manager" = lib.getExe file-manager.package;
        "$menu" = menu;
        "$terminal" = terminal.emulator;
        "$lock" = lock;

        general = with palette; {
          gaps_in = 3;
          gaps_out = 6;

          border_size = 2;
          resize_on_border = false;
          "col.active_border" = mkForce "rgba(${base0D}ff) rgba(${base0E}ff) 45deg";
          "col.inactive_border" = mkForce "transparent";

          layout = "dwindle";
          allow_tearing = true; # For gaming. Set windowrule `immediate` for games to enable.
        };

        misc.disable_hyprland_logo = true;

        input = {
          kb_layout = "us(colemak_dh),eu";
          kb_options = "caps:escape,grp:rctrl_toggle";
          resolve_binds_by_sym = true;
          repeat_delay = 400;
          follow_mouse = 2;
          accel_profile = "flat";
          touchpad = {
            # scroll_factor = 0.7;
            natural_scroll = true;
          };
          special_fallthrough = true;
        };
        cursor = {
          no_hardware_cursors = true;
        };

        decoration = {
          rounding = 10;
          shadow = {
            enabled = false;
          };
          dim_special = 0.2;
          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
          };
        };

        xwayland = {
          force_zero_scaling = true;
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
            "workspaces, 0, 4, wind"
          ];
        };

        exec-once = [
          "discord"
          "nm-applet"
          "blueman-applet"
          "obsidian"
          "todoist-electron"
        ];
      };
      extraConfig = # hyprlang
        ''
          source = ~/.config/hypr/devices.conf
          source = ~/.config/hypr/monitors.conf
          source = ~/.config/hypr/keybindings.conf
          source = ~/.config/hypr/windowrules.conf
        '';

      plugins = [
        # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
    };
  };
}

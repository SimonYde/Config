{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  colorScheme = config.colorScheme;
  palette = colorScheme.palette;
  random-background = pkgs.callPackage ./ran_bg.nix { };
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
      swww # Background daemon
      random-background # random background script
      hyprland-gamemode # disable hyprland animations for games
      playerctl # media keys
      pamixer # volume keys
      networkmanagerapplet

      pavucontrol # audio control

      grimblast # screenshot tool
      wl-clipboard # clipboard manager
      hyprpicker # color picker
    ];

    # home.sessionVariables.NIXOS_OZONE_WL = "1";

    programs = {
      imv.enable = true;
      mpv.enable = true;
      rofi.enable = true;
      swaylock.enable = true;
      wlogout.enable = true;
      hyprlock.enable = false;
      waybar.enable = true;
    };

    services = {
      dunst.enable = false;
      hypridle.enable = true;
      swaync.enable = true;
    };

    wayland.windowManager.hyprland = {
      settings = {
        "$browser" = browser;
        "$file-manager" = file-manager;
        "$menu" = menu;
        "$terminal" = terminal.emulator;
        "$lock" = lock;

        general = with palette; {
          gaps_in = 3;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = lib.mkForce "rgba(${base0D}ff) rgba(${base0E}ff) 45deg";
          "col.inactive_border" = lib.mkForce "transparent";

          layout = "dwindle";
          resize_on_border = true;
          allow_tearing = true; # For gaming. Set windowrule `immediate` for games to enable.
        };

        misc.disable_hyprland_logo = true;

        input = {
          kb_layout = "us(colemak_dh),eu";
          kb_options = "caps:escape,grp:rctrl_toggle";
          resolve_binds_by_sym = true;
          repeat_delay = 200;
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
          blur = {
            enabled = true;
            size = 6;
            passes = 2;
            new_optimizations = true;
            ignore_opacity = true;
            xray = false;
          };
          drop_shadow = false;
          dim_special = 0.2;
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
          "[workspace 9] discord"
          "waybar"
          "nm-applet"
          "blueman-applet"
          "${pkgs.swww}/bin/swww-daemon"
          "[workspace 1] obsidian"
          "${random-background}/bin/ran_bg"
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
  # imports = [ inputs.hyprland.homeManagerModules.default ];
}

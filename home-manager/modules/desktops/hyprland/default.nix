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

        monitor = [
          "desc:Lenovo Group Limited L24i-10 U3P0M4Y1, 1920x1080@60, -1920x0, 1"
          "desc:ASUSTek COMPUTER INC VG27A M1LMQS176051, 2560x1440@165, 0x0, 1, vrr, 2"
          "desc:Philips Consumer Electronics Company PHL 243V7 UK02030003208, 1920x1080@75, 2560x0, 1"
          "desc:Ancor Communications Inc VG248 FBLMQS053462, 1920x1080@119.982002, 0x-1080, 1"
          "desc:Dell Inc. DELL U2722D 5TNW7P3, 2560x1440@60, 0x-1440, 1"
          "desc:HP Inc. HP E273q 6CM9191YW0, 2560x1440@60, 0x-1440, 1,transform,0"
          "desc:HP Inc. HP E273q 6CM9191ZBN, 2560x1440@60, 0x-1440, 1,transform,0"
          "desc:HP Inc. HP E273q 6CM9191ZBQ, 2560x1440@60, 0x-1440, 1,transform,0" # I hate this
          "eDP-1, 1920x1080, 0x0, 1"
          "Unknown-1,disabled"
          ",preferred,auto,1,transform,0"
        ];

        "$browser" = browser;
        "$filemanager" = "${pkgs.xfce.thunar}/bin/thunar";
        "$menu" = menu;
        "$terminal" = terminal.emulator;
        "$lock" = lock;

        exec-once = [
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
          source = ~/.config/hypr/keybindings.conf
          source = ~/.config/hypr/windowrules.conf
        '';

      plugins = [
        # inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      ];
    };
  };
  imports = [ inputs.hyprland.homeManagerModules.default ];
}

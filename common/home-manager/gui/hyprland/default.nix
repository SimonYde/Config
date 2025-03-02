{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    getExe
    mkForce
    ;
  inherit (config.lib.stylix) colors;
  inherit (config.syde.gui) file-manager terminal browser;
  rgb = color: "rgb(${color})";
  hyprland-gamemode = pkgs.callPackage ./gamemode.nix { };
  menu = "${getExe config.programs.rofi.package} -show drun";
in
{
  imports = [
    ./gammastep.nix
    ./hyprsunset.nix
    ./hypridle.nix
    ./hyprlock.nix
    ./hyprland-autoname-workspaces.nix
    ./hyprpaper.nix
  ];

  home.packages = with pkgs; [
    hyprland-gamemode # disable hyprland animations for games
    playerctl # media keys

    pwvucontrol # audio control
    hyprsunset # blue-light filter

    grimblast # screenshot tool
    wl-clipboard # clipboard manager
    hyprpicker # color picker
  ];

  programs = {
    imv.enable = true;
    mpv.enable = true;
    rofi.enable = true;
    wlogout.enable = true;
    hyprlock.enable = true;
    waybar.enable = true;
  };

  syde.services = {
    hyprland-autoname-workspaces.enable = true;
    hyprsunset.enable = false;
  };

  services = {
    # Tray applets
    blueman-applet.enable = true;
    network-manager-applet.enable = true;

    gammastep.enable = true;
    hypridle.enable = true;
    hyprpaper.enable = true;
    swaync.enable = true;
    swayosd.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      # hyprsplit
      hyprspace
    ];
    settings = {
      "$browser" = browser;
      "$file-manager" = getExe file-manager.package;
      "$menu" = menu;
      "$terminal" = terminal;
      "$mod" = "SUPER";

      general = with colors; {
        gaps_in = 3;
        gaps_out = 6;

        border_size = 2;
        resize_on_border = false;
        "col.active_border" = mkForce "${rgb base0D} ${rgb base0E} 45deg";
        "col.inactive_border" = mkForce "rgba(00000000)";

        layout = "dwindle";
        allow_tearing = true; # For gaming. Set windowrule `immediate` for games to enable.
      };

      misc = {
        disable_hyprland_logo = true;
        allow_session_lock_restore = true;
      };

      input = {
        kb_layout = config.home.keyboard.layout;
        kb_options = concatStringsSep "," config.home.keyboard.options;
        resolve_binds_by_sym = true;
        repeat_delay = 300;
        follow_mouse = 2;
        accel_profile = "flat";
        touchpad = {
          tap-to-click = true;
          natural_scroll = true;
        };
        special_fallthrough = true;
      };
      cursor = {
        no_hardware_cursors = 2;
      };

      group.groupbar.text_color = mkForce "rgb(${colors.base00})";

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
          "fade, 1, 7, default"
          "workspaces, 0, 4, wind"
        ];
      };

      exec-once = [
        "discord"
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
  };
}

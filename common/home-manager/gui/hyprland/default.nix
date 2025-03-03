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
    mkOrder
    mkForce
    ;
  inherit (config.lib.stylix) colors;
  inherit (config.syde.gui) file-manager terminal browser;

  hyprland-gamemode = pkgs.callPackage ./gamemode.nix { };
in
{
  imports = [
    ./hyprlock.nix
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

  services = {
    # Tray applets
    blueman-applet.enable = true;
    network-manager-applet.enable = true;

    gammastep.enable = true;

    hypridle = {
      enable = true;

      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "loginctl lock-session";
          ignore_dbus_inhibit = false;
        };
        listener = [
          {
            timeout = 360;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

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
      "$menu" = "${getExe config.programs.rofi.package} -show drun";
      "$terminal" = terminal;
      "$mod" = "SUPER";

      general = with colors; {
        "col.active_border" = mkForce "rgb(${base0D}) rgb(${base0E}) 45deg";
        "col.inactive_border" = mkForce "rgba(00000000)";
      };

      group.groupbar.text_color = mkForce "rgb(${colors.base00})";

      input = {
        kb_layout = config.home.keyboard.layout;
        kb_options = concatStringsSep "," config.home.keyboard.options;
      };
    };
    # Delegate other options to a normal hyprland config.
    extraConfig = mkOrder 1000 ''
      source = ~/.config/hypr/my-hyprland.conf
    '';
  };

  systemd.user = {
    timers = {
      hyprsunset-night = {
        Unit = {
          Description = "Enable Hyprsunset blue-light filter";
          PartOf = [ "hyprland-session.target" ];
          After = [ "hyprland-session.target" ];
        };
        Timer = {
          OnCalendar = "21:00:00";
          Unit = "hyprsunset-night.service";
          Persistent = true;
        };
        Install.WantedBy = [ "hyprland-session.target" ];
      };
      hyprsunset-day = {
        Unit = {
          Description = "Disable Hyprsunset blue-light filter";
          PartOf = [ "hyprland-session.target" ];
          After = [ "hyprland-session.target" ];
        };
        Timer = {
          OnCalendar = "06:00:00";
          Unit = "hyprsunset-day.service";
          Persistent = true;
        };
        Install.WantedBy = [ "hyprland-session.target" ];
      };
    };

    services = {
      hyprsunset-night = {
        Unit.Description = "Hyprsunset - nighttime";
        Service = {
          Type = "oneshot";
          ExecStart = "${getExe pkgs.hyprsunset} -t 1800";
        };
      };

      hyprsunset-day = {
        Unit = {
          Description = "Hyprsunset - daytime";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${getExe pkgs.hyprsunset} --identity";
        };
      };

      hyprland-autoname-workspaces = {
        Unit = {
          Description = "hyprland-autoname-workspaces";
          PartOf = [ "hyprland-session.target" ];
          After = [
            "hyprland-session.target"
          ];
        };
        Install.WantedBy = [ "hyprland-session.target" ];
        Service = {
          ExecStart = getExe pkgs.hyprland-autoname-workspaces;
          Restart = "always";
          RestartSec = "2";
        };
      };
    };
  };
}

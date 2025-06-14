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
  inherit (config.syde.gui) file-manager terminal browser;

  hyprland-gamemode = pkgs.writeShellScriptBin "hyprland-gamemode" ''
    HYPRGAMEMODE=$(hyprctl getoption animations:enabled | sed -n '1p' | awk '{print $2}')

    # Hyprland performance
    if [ $HYPRGAMEMODE = 1 ]; then
        hyprctl --batch "\
            keyword animations:enabled 0;\
            keyword decoration:drop_shadow 0;\
            keyword decoration:blur:enabled 0;\
            keyword general:gaps_in 0;\
            keyword general:gaps_out 0;\
            keyword general:border_size 1;\
            keyword decoration:rounding 0"

        systemctl --user stop waybar.service hyprland-autoname-workspaces.service swww.service
    else
        hyprctl reload
        systemctl --user start waybar.service hyprland-autoname-workspaces.service swww.service
    fi
  '';
in
{
  wayland.systemd.target = "hyprland-session.target";

  home.packages = with pkgs; [
    # My scripts
    hyprland-gamemode

    # Extra utilities
    pwvucontrol # audio control

    grimblast # screenshot tool
    wl-clipboard # clipboard manager
    hyprpicker # color picker

    nwg-displays # Monitor settings
  ];

  programs = {
    anyrun.enable = true;
    hyprlock.enable = true;
    imv.enable = true;
    waybar.enable = true;
    wlogout.enable = true;
  };

  services = {
    blueman-applet.enable = true; # Bluetooth applet
    network-manager-applet.enable = true;

    gammastep.enable = true;
    hypridle.enable = true;

    swaync.enable = true;
    swayosd.enable = true;
    swww.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;

    # plugins = with pkgs.hyprlandPlugins; [ ];

    settings = {
      "$browser" = browser;
      "$file-manager" = getExe file-manager.package;
      "$terminal" = getExe terminal.package;

      input = {
        kb_layout = config.home.keyboard.layout;
        kb_variant = config.home.keyboard.variant;
        kb_options = concatStringsSep "," config.home.keyboard.options;
      };
    };

    # NOTE: Delegate other options to a normal Hyprland config.
    extraConfig = mkOrder 1000 ''
      source = ~/.config/hypr/my-hyprland.conf
    '';
  };

  programs.hyprlock.settings = {
    general = {
      disable_loading_bar = false;
      ignore_empty_input = true;
      grace = 2;
      hide_cursor = true;
      no_fade_in = false;
    };

    background = mkForce {
      monitor = "";
      path = "screenshot";
      blur_passes = 3;
      blur_size = 8;
    };

    input-field = {
      monitor = "";
      size = "200, 50";
      outline_thickness = 2;
      dots_center = true;
      fade_on_empty = true;
      placeholder_text = "<i>Password...</i>";
      position = "0, -80";
      shadow_passes = 2;
    };

    label = {
      monitor = "";
      text = ''cmd[update:4000] echo "<b><big>$TIME</big></b>"'';
      text_align = "center";
      font_size = 110;
      rotate = 0;
      position = "0, 80";
      halign = "center";
      valign = "center";
      shadow_passes = 2;
    };
  };

  services.gammastep = {
    temperature.day = 6000;
    temperature.night = 1800;
    tray = true;
    duskTime = "19:35-21:15";
    dawnTime = "6:00-7:45";
    latitude = 56.0;
    longitude = 10.0;
  };

  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
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

  services.hyprpaper.settings.ipc = "on";

  systemd.user = {
    services = {
      hyprland-autoname-workspaces = {
        Unit = {
          Description = "hyprland-autoname-workspaces";
          After = [ config.wayland.systemd.target ];
          Requires = [ "waybar.service" ];
          PartOf = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStart = getExe pkgs.hyprland-autoname-workspaces;
          Restart = "always";
          RestartSec = "2";
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
  };
}

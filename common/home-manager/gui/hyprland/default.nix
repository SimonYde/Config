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
        systemctl --user stop waybar.service hyprland-autoname-workspaces.service
    else
        hyprctl reload
        systemctl --user start waybar.service hyprland-autoname-workspaces.service
    fi
  '';
in
{
  imports = [ ./random-wallpaper.nix ];

  home.packages = with pkgs; [
    hyprland-gamemode
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
      "$menu" = "${getExe config.programs.rofi.package} -show drun";
      "$terminal" = terminal.name;

      input = {
        kb_layout = config.home.keyboard.layout;
        kb_options = concatStringsSep "," config.home.keyboard.options;
      };
    };
    # NOTE: Delegate other options to a normal hyprland config.
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
      text = ''cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
      text_align = "center";
      font_size = 45;
      font_family = config.stylix.fonts.sansSerif.name;
      rotate = 0;
      position = "0, 80";
      halign = "center";
      valign = "center";
      shadow_passes = 2;
    };
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

  systemd.user = {
    services = {
      hyprland-autoname-workspaces = {
        Unit = {
          Description = "hyprland-autoname-workspaces";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStart = getExe pkgs.hyprland-autoname-workspaces;
          Restart = "always";
          RestartSec = "2";
        };

        Install.WantedBy = [ "hyprland-session.target" ];
      };
    };
  };
}

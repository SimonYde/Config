{
  lib,
  pkgs,
  config,
  options,
  inputs,
  ...
}:
let
  inherit (lib)
    getExe
    mkOrder
    mkForce
    ;
  inherit (config.syde.gui) file-manager terminal browser;
in
{
  home.packages = with pkgs; [
    wl-clipboard # clipboard manager
    hyprpicker # color picker
    hyprpwcenter # audio graph

    nwg-displays # Display settings
  ];

  programs = {
    rofi.enable = true;
    hyprshot.enable = true;
    hyprlock.enable = true;
    waybar.enable = true;
    walker.enable = true;
    wlogout.enable = true;
  };

  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;

    hypridle.enable = true;
    hyprsunset.enable = true;
    hyprpolkitagent.enable = true;

    swaync.enable = true;
    swayosd.enable = true;
    awww.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    plugins = with pkgs.hyprlandPlugins; [ ];

    settings = {
      "$browser" = getExe browser.package;
      "$file-manager" = getExe file-manager.package;
      "$terminal" = getExe terminal.package;

      input = {
        kb_layout = config.home.keyboard.layout;
        kb_variant = config.home.keyboard.variant;
        kb_options = builtins.concatStringsSep "," config.home.keyboard.options;
      };
    };

    # NOTE: Delegate other options to a normal Hyprland config.
    extraConfig = mkOrder 1000 ''
      source = ~/.config/hypr/my-hyprland.conf
    '';
  };

  programs.hyprlock.settings = {
    general = {
      hide_cursor = true;
      ignore_empty_input = true;
      immediate_render = true;
    };

    background = mkForce {
      monitor = "";
      path = "$XDG_RUNTIME_DIR/current-wallpaper";
      blur_passes = 2;
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

  programs.walker.runAsService = true;
  programs.walker.config = options.programs.walker.config.default;
  # programs.walker.package = inputs.walker.packages.${pkgs.stdenv.hostPlatform.system}.walker;

  programs.elephant.package = pkgs.elephant;
  programs.elephant.provider = {
    websearch = {
      settings = {
        entries = [
          {
            name = "Kagi";
            url = "https://kagi.com/search?q=%TERM%";
            default = true;
          }
        ];
      };

    };
  };


  services.hyprsunset.settings = {
    max-gamma = 150;

    profile = [
      {
        time = "7:00";
        identity = true;
      }
      {
        time = "20:00";
        temperature = 4000;
        gamma = 0.9;
      }
      {
        time = "21:00";
        temperature = 3500;
        gamma = 0.8;
      }
      {
        time = "21:30";
        temperature = 3000;
        gamma = 0.8;
      }
      {
        time = "22:00";
        temperature = 2500;
        gamma = 0.75;
      }
      {
        time = "22:30";
        temperature = 1900;
        gamma = 0.7;
      }
    ];
  };

  services.hypridle.settings =
    let
      restartHyprsunset = "systemctl --user restart hyprsunset.service";
    in
    {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on && ${restartHyprsunset}";
        before_sleep_cmd = "loginctl lock-session";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 360;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on && ${restartHyprsunset}";
        }
      ];
    };

  systemd.user = {
    services.hyprland-autoname-workspaces = {
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
}

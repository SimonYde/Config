{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (config.syde.gui) terminal;

  audioctl = lib.getExe pkgs.pavucontrol;
in
{
  programs.waybar = {
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      spacing = 0;
      output = [ "*" ];

      modules-left = [
        "hyprland/workspaces"
        "hyprland/submap"
      ];

      modules-center = [
        "clock"
      ];

      modules-right = [
        "hyprland/language"
        "gamemode"
        "disk"
        "custom/separator#blank"
        "pulseaudio#output"
        "custom/separator#blank"
        "pulseaudio#input"
        "custom/separator#blank"
        "memory"
        "custom/separator#blank"
        "cpu"
        "battery"
        "tray"
        "idle_inhibitor"
        "custom/swaync"
      ];

      gamemode = {
        format = " {glyph}";
        format-alt = "{glyph} {count}";
        glyph = "";
        hide-not-running = true;
        use-icon = true;
        icon-name = "input-gaming-symbolic";
        icon-spacing = 4;
        icon-size = 20;
        tooltip = true;
        tooltip-format = "Games running: {count}";
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          deactivated = "󰌶";
          activated = "󰛨";
        };
      };

      # module definitions
      disk = {
        format = " 󰋊{free}";
        path = "/";
        states = {
          critical = 0;
          good = 12;
        };
        format-good = "";
      };

      memory = {
        format = "{}%";
        on-click = "${lib.getExe terminal.package} -e btop";
      };

      cpu = {
        format = "󰍛{usage}%";
        tooltip = false;
        on-click = "${lib.getExe terminal.package} -e btop";
      };

      clock = {
        format = " {:%R} ";
        format-alt = " {:%a. %d of %B, %Y} ";
        tooltip = false;

        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      tray = {
        spacing = 10;
      };

      "sway/mode" = {
        format = "<span style='italic'>{}</span>";
      };

      "hyprland/submap" = {
        format = "<span style='italic'>{}</span>";
      };

      "hyprland/language" = {
        format = "{}";
        format-dk = " DANSK";
        format-da = " DANSK";
        format-en-colemak_dh = "";
        format-eu = "";
      };

      "hyprland/workspaces" = {
        artive-only = false;
        all-outputs = false;
        format = "{name}";
        show-special = false;
        on-click = "activate";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        "persistent-workspaces" = { };
        "format-icons" = {
          "active" = "";
          "default" = "";
        };
      };

      "custom/swaync" = {
        tooltip = true;
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "sleep 0.1 && swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;

        format = " {icon} {text} ";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
      };

      battery = {
        states = {
          good = 80;
          warning = 30;
          critical = 15;
        };

        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = " {time} {icon}";
        format-icons = [
          "󰂎"
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
      };

      "custom/separator#blank" = {
        format = " ";
        interval = "once";
        tooltip = false;
      };

      "pulseaudio#output" = {
        "scroll-step" = 5;
        "format" = "{volume}% {icon}";
        "format-muted" = "󰝟";
        "format-bluetooth" = "󰂯 {icon} {volume}%";
        "format-bluetooth-muted" = "󰂯 󰝟 {volume}%";
        "format-icons" = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
        "reverse-scroll" = true; # Only applies to trackpad.
        "on-click" = "${audioctl} -t 3";
      };

      "pulseaudio#input" = {
        "format" = "{format_source}";
        "format-source" = "󰍬";
        "format-source-muted" = "󰍭";
        "on-click" = "${audioctl} -t 4"; # -t 4 opens pavucontrol to input tab.
      };
    };
  };

}

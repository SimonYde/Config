{ lib, pkgs, ... }:
let
  inherit (lib) getExe;
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

      modules-center = [ ];

      modules-right = [
        "gamemode"
        "pulseaudio"
        "disk"
        "memory"
        "cpu"
        "battery"
        "custom/separator#blank"
        "tray"
        "custom/separator#blank"
        "clock"
        "idle_inhibitor"
        "custom/swaync"
      ];

      gamemode = {
        format = "{glyph}";
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
        format = " {icon} ";
        format-icons = {
          deactivated = "󰌶";
          activated = "󰛨";
        };
      };

      # module definitions
      disk = {
        format = " {free} 󰋊 ";
        path = "/";
      };

      memory = {
        format = " {}% 󰍛 ";
      };

      cpu = {
        format = " {usage}% 󰾆 ";
        tooltip = false;
      };

      clock = {
        format = " {:%a. %d/%m, %R} ";
        format-alt = " {:%a. %b. %d, %Y (%T)} ";
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

        format = " {icon} {} ";
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

      network = {
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} 󰈀";
        tooltip-format = "{ifname} via {gwaddr} 󰈀";
        format-linked = "{ifname} (No IP) 󰈀";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname}: {ipaddr}/{cidr}";
      };

      battery = {
        states = {
          good = 80;
          warning = 30;
          critical = 15;
        };

        format = " {capacity}% {icon} ";
        format-charging = " {capacity}%  ";
        format-plugged = " {capacity}%  ";
        format-alt = " {time} {icon} ";
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

      pulseaudio = {
        scroll-step = 10; # %, can be a float
        format = " {volume}% {icon} {format_source} ";
        format-muted = "  {format_source} ";
        format-bluetooth = " {volume}% {icon} {format_source} ";
        format-bluetooth-muted = "  {icon} {format_source} ";
        format-source = " {volume}%  ";
        format-source-muted = "";

        format-icons = {
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
        on-click = getExe pkgs.pwvucontrol;
      };
    };
  };

}

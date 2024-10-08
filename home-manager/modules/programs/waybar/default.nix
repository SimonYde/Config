{ config, pkgs, ... }:
let
  palette = config.syde.theming.palette-hex;
  terminal = config.syde.terminal;
  emulator = terminal.emulator;
  font = config.syde.theming.fonts.sansSerif;
in
{
  programs.waybar = {
    # package = inputs.waybar.packages.${pkgs.system}.default;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        # height = 25;
        # margin-left = 12;
        # margin-right = 12;
        ipc = true;
        passthrough = false;
        exclusive = true;
        fixed-center = true;
        spacing = 0;
        output = [ "*" ];
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"

          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = [
          "hyprland/window"
          "sway/window"
        ];
        modules-right = [
          "pulseaudio"
          # "custom/separator#blank"
          "disk"
          # "custom/separator#blank"
          "memory"
          # "custom/separator#blank"
          "cpu"
          # "custom/separator#blank"
          "battery"
          "custom/separator#blank"
          "tray"
          "custom/separator#blank"
          "clock"
          # "custom/separator#blank"
          "idle_inhibitor"
          # "custom/separator#blank"
          "custom/swaync"
          # "custom/separator#blank"
        ];

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
          on-click = "${emulator} -e ${pkgs.btop}/bin/btop";
        };
        cpu = {
          format = " {usage}% 󰾆 ";
          tooltip = false;
        };
        clock = {
          format = " {:%H:%M} ";
          format-alt = " {:%a. %b. %d, %Y (%R)} ";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = with palette; {
              months = "<span color='${base0F}'><b>{}</b></span>";
              days = "<span color='${base0E}'><b>{}</b></span>";
              weeks = "<span color='${base0C}'><b>W{}</b></span>";
              weekdays = "<span color='${base09}'><b>{}</b></span>";
              today = "<span color='${base08}'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };
        tray = {
          # icon-size = 20;
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
        "hyprland/workspaces#icons" = {
          format = " {icon} ";
          show-special = false;
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          all-outputs = false;
          sort-by-number = true;
          format-icons = {
            "1" = "󰚸";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
            "7" = "";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "focused" = "";
            "default" = "";
          };
        };

        "custom/swaync" = {
          tooltip = true;
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
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
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
          # format-icons = [ "" "" "" "" "" ];
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
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
      };
    };

    style =
      # css
      with palette;
      ''
        @define-color base00 ${base00};
        @define-color base01 ${base01};
        @define-color base02 ${base02};
        @define-color base03 ${base03};
        @define-color base04 ${base04};
        @define-color base05 ${base05};
        @define-color base06 ${base06};
        @define-color base07 ${base07};
        @define-color base08 ${base08};
        @define-color base09 ${base09};
        @define-color base0A ${base0A};
        @define-color base0B ${base0B};
        @define-color base0C ${base0C};
        @define-color base0D ${base0D};
        @define-color base0E ${base0E};
        @define-color base0F ${base0F};

        @define-color background      alpha(${base00}, .7);
        @define-color text            ${base0D};
        @define-color background-alt  alpha(${base01}, .7);
        @define-color selected        ${base04};
        @define-color hover           alpha(@selected, .4);
        @define-color urgent          ${base08};

        * {
          font-family: ${font.name}, FontAwesome;
          font-size: 14px;
        }
      ''
      + builtins.readFile ./style.css;
  };
}

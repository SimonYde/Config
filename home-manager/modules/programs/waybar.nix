{
  config,
  inputs,
  pkgs,
  ...
}:
let
  palette = config.colorScheme.palette;
  hexToRGBString = inputs.nix-colors.lib.conversions.hexToRGBString ",";
  terminal = config.syde.terminal;
  emulator = terminal.emulator;
  font = config.syde.theming.fonts.sansSerif;
in
{
  programs.waybar = {
    # package = inputs.waybar.packages.${pkgs.system}.default;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 25;
        output = [ "*" ];
        modules-left = [
          "hyprland/workspaces#icons"
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
          # "network"
          "disk"
          "memory"
          "cpu"
          "battery"
          "tray"
          "clock"
        ];

        # module definitions
        disk = {
          format = "{free} 󰋊";
          path = "/";
        };
        memory = {
          format = "{}% 󰾆";
          on-click = "${emulator} -e ${pkgs.btop}/bin/btop";
        };
        cpu = {
          format = "{usage}% 󰍛";
          tooltip = false;
        };
        tray = {
          # icon-size = 20;
          spacing = 10;
        };
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "hyprland/submap" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "hyprland/workspaces" = {
          artive-only = false;
          all-outputs = true;
          format = "{icon}";
          show-special = false;
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          "persistent-workspaces" = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
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
          all-outputs = true;
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

          format = "{capacity}% {icon}";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
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
        pulseaudio = {
          scroll-step = 10; # %, can be a float
          format = "{volume}% {icon} {format_source}";
          format-muted = " {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-source = "{volume}% ";
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
      with palette;
      let
        bg = "rgba(${hexToRGBString base00},0.7)";
        margin = "6px";
        font-size = "15px";
        padding = "12px";
      in
      ''
        * {
            border: none;
            border-radius: 15px;
            font-family: ${font.name}, FontAwesome;
            min-height: 12px;
        }

        window#waybar {
            background: transparent;
            color: #${base05};
        }

        window#waybar.hidden {
            opacity: 0.2;
            color: #${base05};
        }

        #workspaces {
            margin-left: ${margin};
            margin-right: ${margin};
            transition: none;
            background: ${bg};
        }

        #workspaces button {
            transition: none;
            color: #${base0D};
            background: transparent;
            margin-top: 0;
            font-size: ${font-size};
        }

        #workspaces button.persistent {
            color: #${base0D};
            font-size: ${font-size};
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        #workspaces button:hover {
            transition: none;
            box-shadow: inherit;
            text-shadow: inherit;
            color: ${bg};
            background: #${base04};
        }

        #workspaces button.focused, #workspaces button.active {
            color: #${base01};
            background: rgba(${hexToRGBString base0D},1.0);
        }

        #mode, #submap {
            padding-left: ${padding};
            padding-right: ${padding};
            transition: none;
            color: #${base01};
            background: #${base0D};
        }


        #pulseaudio {
            margin-right: ${margin};
            padding-left: ${padding};
            padding-right: ${padding};
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #pulseaudio.muted {
            background-color: ${bg};
            color: #${base05};
        }

        #memory, #cpu, #disk {
            padding-left: ${padding};
            padding-right: ${padding};
            margin-right: ${margin};
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #battery {
            margin-right: ${margin};
            padding-left: ${padding};
            padding-right: ${padding};
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #battery.charging {
            color: ${bg};
            background-color: #${base0D};
        }

        #battery.warning:not(.charging) {
            background-color: #${base09};
            color: ${bg};
        }

        #battery.critical:not(.charging) {
            background-color: #${base08};
            color: ${bg};
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }

        #tray {
            padding-left: ${padding};
            padding-right: ${padding};
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #clock {
            margin-left: ${margin};
            padding-left: ${padding};
            padding-right: ${padding};
            margin-right: ${margin};
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        @keyframes blink {
            to {
                background-color: #${base05};
                color: ${bg};
            }
        }

        #language {
            padding-left: ${padding};
            padding-right: ${padding};
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #keyboard-state {
            margin-right: ${margin};
            padding-right: ${padding};
            transition: none;
            color: #${base05};
            background: ${bg};
        }
      '';
  };
}

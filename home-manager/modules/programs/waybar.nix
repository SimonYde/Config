{ config, inputs, pkgs, ... }:

let
  colors = config.colorScheme.palette;
  hexToRGBString = inputs.nix-colors.lib.conversions.hexToRGBString ",";
  font = config.syde.terminal.font;
in
{
  programs.waybar = {
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 25;
        output = [
          "*"
        ];
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
          # "network"
          "memory"
          "cpu"
          "battery"
          "tray"
          "clock"
        ];
        disk = {
          format = "{free} ";
          path = "/";
        };
        memory = {
          format = "{}% 󰍛";
        };
        cpu = {
          format = "{usage}% ";
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
        # "hyprland/workspaces" = {
        #   "format" = "<sub>{icon}</sub>\n{windows}";
        #   "format-window-separator" = "\n";
        #   "window-rewrite-default" = "";
        #   "window-rewrite" = {
        #     "title<.*youtube.*>" = ""; # Windows whose titles contain "youtube"
        #     "class<firefox>" = ""; # Windows whose classes are "firefox"
        #     "class<firefox> title<.*github.*>" = ""; # Windows whose class is "firefox" and title contains "github". Note that "class" always comes first.
        #     "alacritty" = "";
        #   };
        # };
        network = {
          # "interface" = "wlp2*"; # (Optional) To force the use of this interface
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
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{time} {icon}";
          format-icons = [ "" "" "" "" "" ];
        };
        pulseaudio = {
          scroll-step = 10; # %, can be a float
          format = "{volume}% {icon} {format_source}";
          format-muted = "󰝟 {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = "󰝟 {icon} {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";

          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [ "" "" "" ];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
      };
    };

    style = with colors;
      let
        bg = "rgba(${hexToRGBString base00},0.85)";
      in
      ''
        * {
            border: none;
            border-radius: 0;
            font-family: ${font}, FontAwesome;
            min-height: 12px;
        }

        window#waybar {
            background: transparent;
        }

        window#waybar.hidden {
            opacity: 0.2;
        }

        #workspaces {
            margin-left: 8px;
            margin-right: 8px;
            border-radius: 10px;
            transition: none;
            background: ${bg};
        }

        #workspaces button {
            transition: none;
            color: #${base07};
            background: transparent;
            padding: 5px;
            font-size: 15px;
        }

        #workspaces button.persistent {
            color: #${base07};
            font-size: 15px;
        }

        /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
        #workspaces button:hover {
            transition: none;
            box-shadow: inherit;
            text-shadow: inherit;
            border-radius: inherit;
            color: ${bg};
            background: #${base04};
        }

        #workspaces button.focused, #workspaces button.active {
            color: #${base01};
            background: rgba(${hexToRGBString base07},0.85);
            border-radius: inherit;
        }

        #language {
            padding-left: 16px;
            padding-right: 8px;
            border-radius: 10px 0px 0px 10px;
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #keyboard-state {
            margin-right: 8px;
            padding-right: 16px;
            border-radius: 0px 10px 10px 0px;
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #mode, #submap {
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #${base01};
            background: #${base07};
        }


        #pulseaudio {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #pulseaudio.muted {
            background-color: ${bg};
            color: #${base05};
        }

        #memory {
            padding-left: 16px;
            padding-right: 8px;
            border-radius: 10px 0px 0px 10px;
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #cpu {
            margin-right: 8px;
            padding-right: 16px;
            border-radius: 0px 10px 10px 0px;
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #battery {
            margin-right: 8px;
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #battery.charging {
            color: ${bg};
            background-color: #${base07};
        }

        #battery.warning:not(.charging) {
            background-color: #${base0A};
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
            padding-left: 16px;
            padding-right: 16px;
            border-radius: 10px;
            transition: none;
            color: #${base05};
            background: ${bg};
        }

        #clock {
            margin-left: 8px;
            padding-left: 16px;
            padding-right: 16px;
            margin-right: 8px;
            border-radius: 10px 10px 10px 10px;
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
      '';
  };
}

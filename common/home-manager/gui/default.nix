{
  lib,
  pkgs,
  config,
  inputs,
  ...
}@args:

let
  inherit (lib)
    getExe
    mkIf
    mkMerge
    mkOption
    types
    ;
  inherit (config.syde.gui) file-manager terminal;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./browser.nix
    ./discord.nix

    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = mkMerge [
    {
      programs = {
        # Terminals
        ghostty.enable = true;
        kitty.enable = false;

        # Browsers
        brave.enable = true;
        firefox.enable = false;

        # other GUI programs
        discord.enable = true;
        mpv.enable = true;
        imv.enable = true;
        spicetify.enable = true;
        zathura.enable = true;
      };

      services = {
        trayscale.enable = true;

        udiskie = {
          enable = true;
          automount = true;
          notify = true;
        };
      };

      # Extra GUI applications
      home.packages = with pkgs; [
        pdfpc # PDF presentation tool
        libreoffice # Office365 replacement
        anki # Flash cards
        obsidian # Second brain
        # gimp # Image editor
        stremio
        rclone-browser

        qbittorrent # Linux ISOs

        todoist-electron
        zotero
      ];

      xdg = {
        userDirs = {
          enable = true;
          createDirectories = false;
        };

        mimeApps = {
          enable = true;

          associations.added = {
            "application/pdf" = [
              "org.pwmt.zathura-pdf-mupdf.desktop"
              "org.pwmt.zathura.desktop"
            ];
          };

          defaultApplications = {
            "inode/directory" = "${file-manager.name}.desktop";

            "application/pdf" = "org.pwmt.zathura.desktop";

            "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
            "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";

            "image/apng" = "imv.desktop";
            "image/gif" = "imv.desktop";
            "image/jpeg" = "imv.desktop";
            "image/png" = "imv.desktop";
            "image/webp" = "imv.desktop";

            "video/mp4" = "mpv.desktop";
            "video/mpv" = "mpv.desktop";
            "video/mpeg" = "mpv.desktop";
          };
        };
      };
    }

    {
      home = {
        keyboard = mkIf (args ? osConfig) {
          inherit (args.osConfig.services.xserver.xkb) layout variant;
          options = lib.splitString "," args.osConfig.services.xserver.xkb.options;
        };

        packages = [
          pkgs.libnotify

          file-manager.package
        ];

        shellAliases.ex = getExe file-manager.package;
        sessionVariables.TERMINAL = terminal;
      };

      programs.nushell.shellAliases.ex = getExe file-manager.package;

      programs = {
        ghostty.settings = {
          gtk-titlebar = false;
          gtk-adwaita = true;
          gtk-single-instance = true;
          unfocused-split-opacity = 0.95;
          window-decoration = false;

          keybind = [
            "ctrl+alt+m=goto_split:left"
            "ctrl+alt+n=goto_split:down"
            "ctrl+alt+e=goto_split:up"
            "ctrl+alt+i=goto_split:right"
            "ctrl+alt+tab=toggle_tab_overview"
          ];
        };

        kitty.settings = {
          disable_ligatures = "never";
          cursor_shape = "beam";
          cursor_blink_interval = 0;
        };

        mpv = {
          defaultProfiles = [ "gpu-hq" ];

          scripts = with pkgs.mpvScripts; [
            sponsorblock
            uosc
            thumbnail
          ];

          config = {
            vo = "gpu";
            hwdec = "auto";
            profile = "gpu-hq";
            ytdl-format = "best[height<=720]";
            osc = "no";
            save-position-on-quit = true;
          };
        };

        rofi = {
          package = pkgs.rofi-wayland;
          terminal = getExe pkgs.${terminal};
          extraConfig = {
            modi = "run,drun";
            icon-theme = "Oranchelo";
            show-icons = true;
            drun-display-format = "{icon} {name}";
            disable-history = false;
            hide-scrollbar = true;
            sidebar-mode = false;
            display-drun = "  Apps ";
            display-run = "  Run ";
          };
          plugins = with pkgs; [
            rofi-emoji-wayland
          ];
        };

        spicetify = {
          enabledCustomApps = with spicePkgs.apps; [
            lyricsPlus
            newReleases
          ];

          enabledExtensions = with spicePkgs.extensions; [
            adblock
            fullAppDisplayMod
            goToSong
            history
          ];
        };

        wlogout.layout = [
          {
            label = "lock";
            action = "loginctl lock-session";
            text = "Lock";
            keybind = "l";
          }

          {
            label = "logout";
            action = "hyprctl dispatch exit 0";
            text = "Logout";
            keybind = "e";
          }

          {
            label = "suspend";
            action = "systemctl suspend";
            text = "Suspend";
            keybind = "s";
          }

          {
            label = "poweroff";
            action = "systemctl poweroff";
            text = "Poweroff";
            keybind = "p";
          }

          {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
          }

          {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
          }
        ];

        waybar = {
          systemd.enable = true;
          settings = {
            mainBar = {
              layer = "top";
              position = "top";
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

                "custom/separator#blank"
                "custom/separator#blank"
                "hyprland/window"
                "sway/window"
              ];
              modules-center = [ ];
              modules-right = [
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
                tooltip-format = "<tt><small>{calendar}</small></tt>";
                calendar = {
                  mode = "year";
                  mode-mon-col = 3;
                  weeks-pos = "right";
                  on-scroll = 1;
                  # format = with colors; {
                  #   months = "<span color='${base0F}'><b>{}</b></span>";
                  #   days = "<span color='${base0E}'><b>{}</b></span>";
                  #   weeks = "<span color='${base0C}'><b>W{}</b></span>";
                  #   weekdays = "<span color='${base09}'><b>{}</b></span>";
                  #   today = "<span color='${base08}'><b><u>{}</u></b></span>";
                  # };
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
                on-click = getExe pkgs.pwvucontrol;
              };
            };
          };
        };
      };

      services.swaync.settings = {
        positionX = "right";
        positionY = "top";

        control-center-width = 380;
        control-center-height = 860;
        control-center-margin-top = 2;
        control-center-margin-bottom = 2;
        control-center-margin-right = 0;
        control-center-margin-left = 20;

        notification-window-width = 400;
        notification-icon-size = 48;
        notification-body-image-height = 160;
        notification-body-image-width = 200;

        timeout = 4;
        timeout-low = 2;
        timeout-critical = 6;

        fit-to-screen = true;
        keyboard-shortcuts = true;
        image-visibility = "when-available";
        transition-time = 200;
        hide-on-clear = true;
        hide-on-action = false;
        script-fail-notify = true;
        scripts = {
          example-script = {
            exec = "echo 'Do something...'";
            urgency = "Normal";
          };
        };
        notification-visibility = {
          example-name = {
            state = "muted";
            urgency = "Low";
            app-name = "Spotify";
          };
        };
        widgets = [
          "label"
          "buttons-grid"
          "mpris"
          "title"
          "dnd"
          "notifications"
        ];
        widget-config = {
          title = {
            text = "Notifications";
            clear-all-button = true;
            button-text = " 󰎟 ";
          };
          dnd = {
            text = "Do not disturb";
          };
          label = {
            max-lines = 1;
            text = " ";
          };
          mpris = {
            image-size = 96;
            image-radius = 12;
          };
          volume = {
            label = "󰕾";
            show-per-app = true;
          };
          buttons-grid = {
            actions = [
              {
                label = "";
                command = "swayosd-client --output-volume mute-toggle --max-volume 200";
              }
              {
                label = "";
                command = "swayosd-client --input-volume mute-toggle";
              }
              {
                label = "";
                command = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
              }
              {
                label = "";
                command = "blueman-manager";
              }
              {
                label = "";
                command = "random-wallpaper";
              }
            ];
          };
        };
      };

      services.gammastep = {
        tray = true;
        provider = "manual";

        duskTime = "18:45-21:00";
        dawnTime = "6:00-7:45";

        latitude = 56.3;
        longitude = 9.5;

        temperature = {
          day = 6500;
          night = 2200;
        };
      };

      xdg.configFile."gammastep/hooks/notify" = {
        inherit (config.services.gammastep) enable;
        executable = true;
        text = # bash
          ''
            #!/usr/bin/env bash
            case $1 in
                period-changed)
                    exec ${lib.getExe pkgs.libnotify} "Gammastep" "Period changed to $3"
            esac
          '';
      };
    }
  ];

  options.syde.gui = {
    browser = mkOption {
      type = types.enum [
        "firefox"
        "brave"
        "floorp"
        "qutebrowser"
        "zen"
      ];
      default = "zen";
    };

    terminal = mkOption {
      type = types.enum [
        "alacritty"
        "kitty"
        "wezterm"
        "foot"
        "ghostty"
      ];
      default = "ghostty";
    };

    file-manager = {
      name = mkOption {
        type = types.str;
        default = "pcmanfm";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.pcmanfm;
      };
    };
  };
}

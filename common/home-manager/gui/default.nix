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
    mkPackageOption
    types
    ;
  inherit (config.syde.gui) file-manager terminal image-viewer;
in
{
  imports = [
    ./browser.nix
    ./audio-production.nix
    ./waybar.nix
    ./swww.nix
    ./walker.nix
  ];

  config = mkMerge [
    {
      programs = {
        # Terminals
        ghostty.enable = true;
        kitty.enable = false;
        alacritty.enable = false;
        wezterm.enable = true;

        # Browsers
        brave.enable = true;
        firefox.enable = false;
        zen-browser.enable = true;

        # other GUI programs
        rclone.enable = true;
        mpv.enable = true;
        ncspot.enable = true;
        imv.enable = true;
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
        gimp3 # Image editor

        qbittorrent # Linux ISOs

        zotero

        legcord

        rclone-browser
        rclone # Remote files

        imagemagick
        kdePackages.ark
        networkmanagerapplet

        yt-dlp
        trashy

        grawlix
        audiobook-dl
        etilbudsavis-cli
      ];

      xdg = {
        userDirs = {
          enable = true;
          createDirectories = false;
        };

        mimeApps = {
          enable = true;

          defaultApplications = {
            "inode/directory" = "${file-manager.name}.desktop";

            "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";

            "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
            "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";

            "image/apng" = "${image-viewer.name}.desktop";
            "image/gif" = "${image-viewer.name}.desktop";
            "image/jpeg" = "${image-viewer.name}.desktop";
            "image/png" = "${image-viewer.name}.desktop";
            "image/webp" = "${image-viewer.name}.desktop";

            "video/mp4" = "mpv.desktop";
            "video/mpv" = "mpv.desktop";
            "video/mpeg" = "mpv.desktop";
            "video/x-matroska" = "mpv.desktop";
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
          terminal.package
        ];

        sessionVariables.TERMINAL = terminal.name;

        shellAliases.ex = getExe file-manager.package;
      };

      age.secrets = {
        "rcloneOnedriveAccessToken".file = "${inputs.secrets}/rcloneOnedriveAccessToken.age";
        "rcloneOnedrivePassword".file = "${inputs.secrets}/rcloneOnedrivePassword.age";
        "rcloneOnedrivePassword2".file = "${inputs.secrets}/rcloneOnedrivePassword2.age";
        "rcloneOnedriveID".file = "${inputs.secrets}/rcloneOnedriveID.age";
      };

      programs = {
        ashell = {
          systemd.enable = true;
          settings = {
            modules = {
              left = [
                "Workspaces"
              ];
              center = [
                "WindowTitle"
              ];
              right = [
                "SystemInfo"
                [
                  "Clock"
                  "Privacy"
                  "Settings"
                ]
                "Tray"
                "CustomNotifications"
              ];
            };

            settings = {
              # command used for lock the system
              # without a value the related button will not appear
              # optional, default None
              lock_cmd = "loginctl lock-session";
              # command used to open the sinks audio settings
              # without a value the related button will not appear
              # optional default None
              audio_sinks_more_cmd = getExe pkgs.pwvucontrol;
              # command used to open the sources audio settings
              # without a value the related button will not appear
              # optional, default None
              audio_sources_more_cmd = getExe pkgs.pwvucontrol;
              # command used to open the network settings
              # without a value the related button will not appear
              # optional, default None
              wifi_more_cmd = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
              # command used to open the VPN settings
              # without a value the related button will not appear
              # optional, default None
              vpn_more_cmd = "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
              # command used to open the Bluetooth settings
              # without a value the related button will not appear
              # optional, default None
              bluetooth_more_cmd = "${pkgs.blueman}/bin/blueman-manager";
            };

            workspaces.visibilityMode = "MonitorSpecific";

            CustomModule = [
              {
                # The name will link the module in your left/center/right definition
                name = "CustomNotifications";
                # The default icon for this custom module
                icon = "";
                # The command that will be executed on click
                command = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
                # You can optionally configure your custom module to update the UI using another command
                # The output right now follows the waybar json-style output, using the `alt` and `text` field
                # E.g. `{"text": "3", "alt": "notification"}`
                listen_cmd = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
                # You can define behavior for the `text` and `alt` fields
                # Any number of regex can be used to change the icon based on the alt field
                "icons.'dnd.*'" = "";
                # Another regex can optionally show a red "alert" dot on the icon
                alert = ".*notification";
              }
            ];
          };
        };

        anyrun.config = {
          showResultsImmediately = false;

          x.fraction = 0.5;
          y.fraction = 0.3;
          height.absolute = 200;

          plugins = [
            "libapplications.so"
            "librink.so"
            "libshell.so"
            "libsymbols.so"
          ];
        };

        ghostty.settings = {
          # Font adjustments
          adjust-underline-position = 4;

          # Window
          gtk-titlebar = false;
          gtk-adwaita = true;
          gtk-single-instance = true;
          window-decoration = false;
          window-padding-balance = true;

          # Other
          mouse-hide-while-typing = true;
          unfocused-split-opacity = 0.95;

          keybind = [
            "ctrl+alt+m=goto_split:left"
            "ctrl+alt+n=goto_split:down"
            "ctrl+alt+e=goto_split:up"
            "ctrl+alt+i=goto_split:right"
            "ctrl+alt+tab=toggle_tab_overview"
            "ctrl+alt+s=write_screen_file:open"
          ];
        };

        ncspot.settings = {
          use_nerdfont = true;
        };

        mpv = {
          defaultProfiles = [ "gpu-hq" ];

          scripts = with pkgs.mpvScripts; [
            sponsorblock
            uosc
            thumbfast
          ];

          config = {
            hwdec = "auto";
            osc = "no";
            osd-bar = "no";
            ytdl-format = "bestvideo+bestaudio";
            save-position-on-quit = true;
          };
        };

        rclone.remotes = {
          onedrive-unencrypted = {
            config = {
              type = "onedrive";
              drive_type = "personal";
            };

            secrets = {
              token = "/run/user/1000/agenix/rcloneOnedriveAccessToken";
              drive_id = "/run/user/1000/agenix/rcloneOnedriveID";
            };
          };

          onedrive = {
            config = {
              type = "crypt";
              remote = "onedrive-unencrypted:crypt";
              filename_encryption = "standard";
            };

            secrets = {
              password = "/run/user/1000/agenix/rcloneOnedrivePassword";
              password2 = "/run/user/1000/agenix/rcloneOnedrivePassword2";
            };
          };
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
        };
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
        "zen-beta"
      ];
      default = "zen-beta";
    };

    file-manager = {
      name = mkOption {
        type = types.str;
        default = "pcmanfm";
      };

      package = mkPackageOption pkgs file-manager.name { };
    };

    terminal = {
      name = mkOption {
        type = types.enum [
          "alacritty"
          "kitty"
          "wezterm"
          "foot"
          "ghostty"
        ];
        default = "wezterm";
      };

      package = mkPackageOption pkgs terminal.name { };
    };

    image-viewer = {
      name = mkOption {
        type = types.enum [
          "imv"
        ];
        default = "imv";
      };

      package = mkPackageOption pkgs image-viewer.name { };
    };
  };
}

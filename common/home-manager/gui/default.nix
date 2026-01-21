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
    mkForce
    mkIf
    mkMerge
    mkOption
    mkPackageOption
    types
    ;

  inherit (config.syde.gui)
    browser
    editor
    file-manager
    image-viewer
    terminal
    video-player
    ;
in
{
  imports = [
    ./browser.nix
    ./waybar.nix
    ./swww.nix
    ./voxtype.nix

    inputs.spicetify-nix.homeManagerModules.default
    inputs.walker.homeManagerModules.default
    inputs.voxtype.homeManagerModules.default
  ];

  config = mkMerge [
    {
      programs = {
        # Terminals
        ghostty.enable = false;
        kitty.enable = false;
        alacritty.enable = false;
        wezterm.enable = true;

        # Browsers
        brave.enable = true;
        firefox.enable = false;
        floorp.enable = true;

        # other GUI programs
        imv.enable = true;
        mpv.enable = true;
        ncspot.enable = false;
        rclone.enable = true;
        spicetify.enable = true;
        vivid.enable = true;
        voxtype.enable = true;
        yt-dlp.enable = true;
        zathura.enable = true;
      };

      services = {
        nextcloud-client = {
          enable = true;
          startInBackground = true;
        };

        tailscale-systray.enable = true;

        udiskie = {
          enable = args ? osConfig && args.osConfig.services.udisks2.enable;
          automount = true;
          notify = true;
        };
      };

      # Extra GUI applications
      home.packages = with pkgs; [
        pdfpc # PDF presentation tool
        libreoffice # Office365 replacement
        obsidian # Second brain
        gimp3 # Image editor

        qbittorrent # Linux ISOs

        tor-browser

        legcord
        discord
        betterdiscordctl

        rclone-browser

        imagemagick
        kdePackages.ark

        trashy

        # grawlix
        # audiobook-dl
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
            "text/markdown" = "${editor.name}.desktop";
            "text/plain" = "${editor.name}.desktop";
            "text/x-csv" = "${editor.name}.desktop";
            "text/x-log" = "${editor.name}.desktop";
            "text/x-patch" = "${editor.name}.desktop";
            "application/xml" = "${editor.name}.desktop";
            "application/x-yaml" = "${editor.name}.desktop";

            "inode/directory" = "${file-manager.name}.desktop";

            "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";

            "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
            "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";

            "image/apng" = "${image-viewer.name}.desktop";
            "image/avif" = "${image-viewer.name}.desktop";
            "image/bmp" = "${image-viewer.name}.desktop";
            "image/heif" = "${image-viewer.name}.desktop";
            "image/gif" = "${image-viewer.name}.desktop";
            "image/jpeg" = "${image-viewer.name}.desktop";
            "image/png" = "${image-viewer.name}.desktop";
            "image/webp" = "${image-viewer.name}.desktop";
            "image/x-icns" = "${image-viewer.name}.desktop";

            "video/mp4" = "${video-player.name}.desktop";
            "video/mpv" = "${video-player.name}.desktop";
            "video/mpeg" = "${video-player.name}.desktop";
            "video/x-matroska" = "${video-player.name}.desktop";

            "x-scheme-handler/http" = "${browser.name}.desktop";
            "x-scheme-handler/https" = "${browser.name}.desktop";
            "x-scheme-handler/chrome" = "${browser.name}.desktop";
            "text/html" = "${browser.name}.desktop";
            "image/svg" = "${browser.name}.desktop";
            "application/x-extension-htm" = "${browser.name}.desktop";
            "application/x-extension-html" = "${browser.name}.desktop";
            "application/x-extension-shtml" = "${browser.name}.desktop";
            "application/xhtml+xml" = "${browser.name}.desktop";
            "application/x-extension-xhtml" = "${browser.name}.desktop";
            "application/x-extension-xht" = "${browser.name}.desktop";
          };
        };

        configFile."mimeapps.list".force = true;
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
          (mkIf (!config.programs ? ${editor.name} || !config.programs.${editor.name}.enable) editor.package)
          (mkIf (
            !config.programs ? ${video-player.name} || !config.programs.${video-player.name}.enable
          ) video-player.package)
          (mkIf (
            !config.programs ? ${image-viewer.name} || !config.programs.${image-viewer.name}.enable
          ) image-viewer.package)
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

      fonts.fontconfig = {
        antialiasing = true;
        subpixelRendering = "rgb";
      };

      programs = {
        ghostty.settings = {
          # Font adjustments
          adjust-underline-position = 4;

          # Window
          gtk-titlebar = true;
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

        spicetify =
          let
            spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
          in
          {
            enabledCustomApps = with spicePkgs.apps; [
              ncsVisualizer
              newReleases
            ];

            enabledExtensions = with spicePkgs.extensions; [
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
    browser = {
      name = mkOption {
        type = types.enum [
          "firefox"
          "brave-browser"
          "floorp"
          "qutebrowser"
        ];
        default = "firefox";
      };

      package = mkPackageOption pkgs browser.name { };
    };

    editor = {
      name = mkOption {
        type = types.str;
        default = "neovim";
      };
      package = mkPackageOption pkgs editor.name { };
    };

    file-manager = {
      name = mkOption {
        description = ''
          Name of the file manager for use with MIME default application mapping.
        '';
        type = types.enum [
          "yazi"
          "thunar"
          "pcmanfm"
          "nautilus"
          "dolphin"
          "com.system76.CosmicFiles"
        ];
        default = "yazi";
      };

      package = mkPackageOption pkgs file-manager.name { };
    };

    image-viewer = {
      name = mkOption {
        description = ''
          Name of the image viewer for use with MIME default application mapping.
        '';
        type = types.enum [
          "imv"
        ];
        default = "imv";
      };

      package = mkPackageOption pkgs image-viewer.name { };
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

    video-player = {
      name = mkOption {
        type = types.str;
        default = "mpv";
      };

      package = mkPackageOption pkgs video-player.name { };
    };
  };
}

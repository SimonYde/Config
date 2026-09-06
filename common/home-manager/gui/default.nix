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
    ./awww.nix
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
        floorp.enable = false;

        # other GUI programs
        imv.enable = true;
        mpv.enable = true;
        ncspot.enable = false;
        spicetify.enable = true;
        vivid.enable = true;
        voxtype.enable = true;
        wayprompt.enable = false;
        thunderbird.enable = false;
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
        # gimp3 # Image editor

        tor-browser

        ferdium

        imagemagick

        trashy

        # grawlix
        # audiobook-dl
        etilbudsavis-cli
      ];

      xdg = {
        userDirs = {
          enable = true;
          setSessionVariables = true;
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
        configFile."autostart/netbird.desktop".source = mkIf (
          args ? osConfig
        ) "${args.osConfig.services.netbird.clients.default.wrapper}/share/applications/netbird.desktop";

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
          pkgs.brightnessctl
          pkgs.playerctl
          pkgs.pavucontrol

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

        thunderbird.profiles.${config.home.username} = {
          isDefault = true;
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
          "brave-origin"
          "floorp"
          "qutebrowser"
        ];
        default = "floorp";
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
          "pqiv"
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

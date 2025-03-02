{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkOption
    types
    ;
  inherit (config.syde.gui) terminal;
in
{
  imports = [
    ./file-manager.nix
    ./browser.nix
    ./terminal.nix

    ./discord.nix
    ./mpv.nix
    ./rofi
    ./spicetify.nix
    ./swaync.nix
    ./waybar
    ./wlogout.nix
  ];

  config = {
    programs = {
      # Browsers
      brave.enable = true;
      firefox.enable = true;

      # other GUI programs
      discord.enable = true;
      mpv.enable = true;
      zathura.enable = true;
      spicetify.enable = true;

      # Ensure terminal is installed
      ${terminal}.enable = mkDefault true;
    };

    services = {
      trayscale.enable = true;

      udiskie = {
        enable = true;
        automount = true;
        notify = true;
      };
    };

    home = {
      packages = with pkgs; [
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

      sessionVariables.TERMINAL = terminal;
    };

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
          "application/pdf" = "org.pwmt.zathura.desktop";

          "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
          "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";

          "image/apng" = "imv.desktop";
          "image/gif" = "imv.desktop";
          "image/jpeg" = "imv.desktop";
          "image/png" = "imv.desktop";
          "image/webp" = "imv.desktop";
        };
      };
    };
  };

  options.syde.gui = {
    browser = mkOption {
      type = types.enum [
        "firefox"
        "brave"
        "floorp"
        "qutebrowser"
      ];
      default = "firefox";
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
      mime = mkOption {
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

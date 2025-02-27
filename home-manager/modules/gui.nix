{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;
  inherit (config.syde.gui) file-manager terminal browser;
  cfg = config.syde.gui;
in
{
  config = mkMerge [
    (mkIf cfg.enable {
      programs = {
        # Browsers
        brave.enable = true;
        firefox.enable = true;

        # other GUI programs
        mangohud.enable = true;
        mpv.enable = true;
        zathura.enable = true;
      };

      syde.desktop.cosmic.files.enable = false;

      syde.gui.terminal = "ghostty";

      # personal program configurations
      syde.programs = {
        discord.enable = true;
      };

      services = {
        trayscale.enable = true;
        udiskie.enable = true;
      };

      home.packages = with pkgs; [
        pdfpc # PDF presentation tool
        libreoffice # Office365 replacement
        anki # Flash cards
        obsidian # Second brain
        gimp # Image editor
        stremio
        rclone-browser

        qbittorrent # Linux ISOs

        todoist-electron
        zotero
      ];
    })

    (mkIf cfg.enable {
      programs.${terminal}.enable = mkDefault true;

      home.sessionVariables.TERMINAL = terminal;

      home.packages = [
        file-manager.package
      ];

      home.shellAliases = {
        ex = lib.getExe file-manager.package;
      };

      xdg.userDirs = {
        enable = true;
        createDirectories = false;
      };

      xdg.mimeApps.enable = true;
      xdg.mimeApps.defaultApplications = {
        "x-scheme-handler/magnet" = "org.qbittorrent.qBittorrent.desktop";
        "application/x-bittorrent" = "org.qbittorrent.qBittorrent.desktop";

        "x-scheme-handler/http" = "${browser}.desktop";
        "x-scheme-handler/https" = "${browser}.desktop";
        "x-scheme-handler/chrome" = "${browser}.desktop";
        "text/html" = "${browser}.desktop";
        "image/svg" = "${browser}.desktop";
        "application/x-extension-htm" = "${browser}.desktop";
        "application/x-extension-html" = "${browser}.desktop";
        "application/x-extension-shtml" = "${browser}.desktop";
        "application/xhtml+xml" = "${browser}.desktop";
        "application/x-extension-xhtml" = "${browser}.desktop";
        "application/x-extension-xht" = "${browser}.desktop";

        "application/zstd" = "${file-manager.mime}.desktop";
        "application/x-lha" = "${file-manager.mime}.desktop";
        "application/x-cpio" = "${file-manager.mime}.desktop";
        "application/x-lzip" = "${file-manager.mime}.desktop";
        "application/x-compress" = "${file-manager.mime}.desktop";
        "application/gzip" = "${file-manager.mime}.desktop";
        "application/zip" = "${file-manager.mime}.desktop";
        "application/x-bzip2" = "${file-manager.mime}.desktop";
        "application/x-xz" = "${file-manager.mime}.desktop";
        "application/x-xar" = "${file-manager.mime}.desktop";
        "application/x-lzma" = "${file-manager.mime}.desktop";
        "inode/directory" = "${file-manager.mime}.desktop";
      };
    })
  ];

  options.syde.gui = {
    enable = mkEnableOption "GUI applications and configuration";
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

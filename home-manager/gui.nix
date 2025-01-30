{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    types
    mkOption
    mkIf
    mkEnableOption
    ;
  cfg = config.syde.gui;
  browser = cfg.browser;
  file-manager = cfg.file-manager;
  emulator = config.syde.terminal.emulator;
in
{
  config = mkIf cfg.enable {
    programs = {
      # Browsers
      brave.enable = true;
      firefox.enable = true;
      qutebrowser.enable = false;

      # Terminal emulators
      ${emulator}.enable = true;

      # other GUI programs
      mangohud.enable = true;
      mpv.enable = true;
      obs-studio.enable = false;
      zathura.enable = true;
    };

    syde.desktop.cosmic.files.enable = false;

    syde.terminal.emulator = "ghostty";

    # personal program configurations
    syde.programs = {
      discord.enable = true;
      discord.package = pkgs.discord;
      thunar = {
        defaultFilemanager = true;
        enable = true;
      };
    };

    services = {
      trayscale.enable = true;
      gammastep.enable = true;
      udiskie.enable = true;
    };

    home.packages = with pkgs; [
      pdfpc # PDF presentation tool
      libreoffice # Office365 replacement
      anki # Flash cards
      obsidian # Second brain
      gimp # Image editor

      qbittorrent # Linux ISOs

      todoist-electron
      zotero

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
  };

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
    file-manager = {
      mime = mkOption {
        type = types.str;
        default = "thunar";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.xfce.thunar;
      };
    };
    lock = mkOption {
      type = types.str;
      default = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };
}

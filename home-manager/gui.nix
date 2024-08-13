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
    optionalAttrs
    mkIf
    mkEnableOption
    ;
  cfg = config.syde.gui;
  browser = config.syde.gui.browser;
  file-manager = config.syde.gui.file-manager;
  emulator = config.syde.terminal.emulator;
in
{
  config = mkIf cfg.enable {
    programs = {
      # Browsers
      brave.enable = true;
      firefox.enable = true;

      # Terminal emulators
      ${emulator}.enable = true;

      # other GUI programs
      vscode.enable = false;
      mangohud.enable = true;
      qutebrowser.enable = false;
      emacs.enable = false;
      mpv.enable = true;
      zathura.enable = true;
    };

    # personal program configurations
    syde.programs = {
      thunar = {
        defaultFilemanager = true;
        enable = false;
      };
    };

    services = {
      kdeconnect.enable = true;
      gammastep.enable = true;
      redshift.enable = false;
      udiskie.enable = true;
    };

    home.packages = with pkgs; [
      # synergy
      pdfpc
      libreoffice
      anki
      obsidian
      gimp

      qbittorrent
      zed-editor

      stremio
      youtube-music
      todoist-electron

      ferdium
      discord
      betterdiscordctl
    ];

    xdg.mimeApps.enable = true;
    xdg.mimeApps.defaultApplications =
      {
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
      }
      // optionalAttrs (file-manager != null) {
        "application/zstd" = "${file-manager}.desktop";
        "application/x-lha" = "${file-manager}.desktop";
        "application/x-cpio" = "${file-manager}.desktop";
        "application/x-lzip" = "${file-manager}.desktop";
        "application/x-compress" = "${file-manager}.desktop";
        "application/gzip" = "${file-manager}.desktop";
        "application/x-bzip2" = "${file-manager}.desktop";
        "application/x-xz" = "${file-manager}.desktop";
        "application/x-xar" = "${file-manager}.desktop";
        "application/x-lzma" = "${file-manager}.desktop";
        "inode/directory" = "${file-manager}.desktop";
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
      default = "floorp";
    };
    file-manager = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    lock = mkOption {
      type = types.str;
      default = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };
}

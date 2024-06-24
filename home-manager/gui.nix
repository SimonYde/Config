{ lib, config, ... }:
let
  inherit (lib) types mkOption optionalAttrs mkIf mkEnableOption;
  cfg = config.syde.gui;
  browser = config.syde.gui.browser;
  file-manager = config.syde.gui.file-manager;
in
{
  config = mkIf cfg.enable {
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
      ];
      default = "floorp";
    };
    file-manager = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
  };
}

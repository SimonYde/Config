{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    removePrefix
    types
    mkOption
    optionalAttrs
    ;
  browser = config.syde.browser;
  file-manager = config.syde.file-manager;
in
{
  config = {
    lib.meta = {
      configPath = "${config.home.homeDirectory}/Config";
      mkMutableSymlink =
        path:
        config.lib.file.mkOutOfStoreSymlink (
          config.lib.meta.configPath + removePrefix (toString inputs.self) (toString path)
        );
    };

    nix = {
      package = lib.mkDefault pkgs.nix;
      extraOptions = ''
        experimental-features = flakes nix-command
        warn-dirty = false
      '';
    };

    xdg.enable = true;
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

  options.syde = {
    unfreePredicates = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
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

  imports = [
    ./home.nix
    ./programming.nix
    ./terminal.nix
    ./modules
  ];
}

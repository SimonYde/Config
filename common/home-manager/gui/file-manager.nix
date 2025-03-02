{ config, lib, ... }:
let
  inherit (config.syde.gui) file-manager;
in
{
  home = {
    packages = [ file-manager.package ];
    shellAliases = {
      ex = lib.getExe file-manager.package;
    };

  };
  xdg.mimeApps.defaultApplications = {
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
}

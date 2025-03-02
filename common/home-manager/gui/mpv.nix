{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.mpv;
in
{
  config = lib.mkIf cfg.enable {
    programs.mpv = {
      defaultProfiles = [ "gpu-hq" ];

      scripts = with pkgs.mpvScripts; [
        sponsorblock
        uosc
        thumbnail
      ];

      config = {
        vo = "gpu";
        hwdec = "auto";
        profile = "gpu-hq";
        ytdl-format = "best[height<=720]";
        osc = "no";
        save-position-on-quit = true;
      };
    };
    xdg.mimeApps.defaultApplications = {
      "video/mp4" = "mpv.desktop";
      "video/mpv" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
    };
  };
}

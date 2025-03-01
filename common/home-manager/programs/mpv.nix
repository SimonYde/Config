{
  pkgs,
  config,
  lib,
  ...
}:
let
  colors = config.lib.stylix.colors.withHashtag;
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

      config = with colors; {
        background = "color";
        background-color = base00;
        osd-back-color = base04;
        osd-border-color = base01;
        osd-color = base05;
        osd-shadow-color = base00;
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

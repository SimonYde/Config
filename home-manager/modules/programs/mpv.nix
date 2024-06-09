{
  pkgs,
  config,
  lib,
  ...
}:
let
  palette = config.syde.theming.palette-hex;
  cfg = config.programs.mpv;
in
{
  config = lib.mkIf cfg.enable {
    programs.mpv = {
      config = with palette; {
        background = base00;
        osd-back-color = base04;
        osd-border-color = base01;
        osd-color = base05;
        osd-shadow-color = base00;
        vo = "gpu";
        hwdec = "auto-safe";
        profile = "gpu-hq";
        ytdl-format = "best[height<=720]";
        osc = "no";
      };
      scripts = with pkgs.mpvScripts; [
        sponsorblock
        thumbnail
      ];
    };
    xdg.mimeApps.defaultApplications = {
      "video/mp4" = "mpv.desktop";
      "video/mpv" = "mpv.desktop";
      "video/mpeg" = "mpv.desktop";
    };
  };
}

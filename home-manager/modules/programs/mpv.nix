{ pkgs, config, ... }:
let
  palette = config.syde.theming.palette_with_hex;
in
{
  programs.mpv = with palette; {
    config = {
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
}

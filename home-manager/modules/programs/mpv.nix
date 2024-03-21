{ lib, pkgs, ... }:

{
  programs.mpv = {
    config = {
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

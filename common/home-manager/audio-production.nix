{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    jamesdsp
    yabridge
    yabridgectl

    reaper
    reaper-reapack-extension
    reaper-sws-extension
  ];

  home.file.".lv2/lsp-plugins.lv2".source = "${pkgs.lsp-plugins}/lib/lv2/lsp-plugins.lv2";
}

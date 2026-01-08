{
  pkgs,
  ...
}:
let
in
{
  home.packages = with pkgs; [
    jamesdsp
    lsp-plugins
    yabridge
    yabridgectl

    reaper
    reaper-reapack-extension
    reaper-sws-extension
  ];
}

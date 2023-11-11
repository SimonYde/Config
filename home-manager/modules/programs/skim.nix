{ config, ... }:

let
  flavour = config.themes.flavour;
  catppuccin = config.themes.catppuccin;
in
{
  programs.skim = {
    enableFishIntegration = true;
    enableZshIntegration = true;
    changeDirWidgetCommand = "fd --type d";
    fileWidgetCommand = "fd --type f";
    defaultOptions = with catppuccin.${flavour}; [
      "--color=${
        builtins.concatStringsSep "," [
          "fg:${text}"
          "matched:${surface0}"
          "matched_bg:${flamingo}"
          "current:${text}"
          "current_bg:${surface1}"
          "current_match:${base}"
          "current_match_bg:${rosewater}"
          "spinner:${green}"
          "info:${mauve}"
          "prompt:${blue}"
          "cursor:${red}"
          "selected:${lavender}"
          "header:${teal}"
          "border:${surface2}"
      ]}"
    ];
  };
}

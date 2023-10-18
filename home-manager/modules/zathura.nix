{ config, ... }:

let
  catppuccin = config.themes.catppuccin;
  flavour = config.themes.flavour;
in
{
  programs.zathura = {
    options = with catppuccin.${flavour}; {
      default-fg = text;
      default-bg = base;

      completion-bg = surface0;
      completion-fg = text;
      completion-highlight-bg = surface2;
      completion-highlight-fg = text;
      completion-group-bg = surface1;
      completion-group-fg = blue;

      statusbar-bg = surface0;
      statusbar-fg = text;

      notification-bg = surface0;
      notification-fg = text;
      notification-error-bg = surface0;
      notification-error-fg = red;
      notification-warning-bg = surface0;
      notification-warning-fg = yellow;

      inputbar-bg = surface0;
      inputbar-fg = text;

      recolor-lightcolor = base;
      recolor-darkcolor = text;

      index-bg = base;
      index-fg = text;
      index-active-bg = surface0;
      index-active-fg = text;

      render-loading-bg = base;
      render-loading-fg = text;

      highlight-color = surface2;
      highlight-active-color = rosewater;
      highlight-fg = rosewater;
    };
  };
}

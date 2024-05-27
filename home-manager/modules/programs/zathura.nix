{ config, lib, ... }:
{
  programs.zathura = {
    options = with config.syde.theming.palette-hex; lib.mkDefault {

      default-bg = base00;
      default-fg = base05;

      statusbar-bg = base02;
      statusbar-fg = base05;

      inputbar-bg = base02;
      inputbar-fg = base05;

      notification-bg = base02;
      notification-fg = base05;

      notification-error-bg = base02;
      notification-error-fg = base08;

      notification-warning-bg = base02;
      notification-warning-fg = base0A;


      index-bg = base00;
      index-fg = base05;
      index-active-bg = base02;
      index-active-fg = base05;

      render-loading = true;
      render-loading-bg = base00;
      render-loading-fg = base05;

      highlight-color = base04;
      highlight-active-color = base06;

      completion-bg = base02;
      completion-fg = base05;

      completion-highlight-bg = base04;
      completion-highlight-fg = base05;

      completion-group-bg = base03;
      completion-group-fg = base0D;

      recolor-lightcolor = base00;
      recolor-darkcolor = base05;

      recolor = false;
      recolor-keephue = false;
    };
  };
}

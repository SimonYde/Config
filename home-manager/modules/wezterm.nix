{ config, pkgs, ... }:

let
  font = config.syde.terminal.font;
in
{
  programs.wezterm = {
    extraConfig = ''
      local wezterm = require 'wezterm'
      return {
        window_frame = {
          border_left_width = '0',
          border_right_width = '0',
          border_bottom_height = '0',
          border_top_height = '0',
        },
        window_padding = {
          left = 0,
          right = 0,
          top = 0,
          bottom = 0,
        },
        window_decorations = "NONE",
        color_scheme = "Catppuccin Mocha",
        enable_tab_bar = false,
        default_cursor_style = "SteadyBar",
        font = wezterm.font {
          family = '${font}',
          weight = 'Light',
          italic = false,
        },
        font_size = 11.5,
        default_prog = {"${pkgs.fish}/bin/fish", "-l"},
      }
    '';
  };
}

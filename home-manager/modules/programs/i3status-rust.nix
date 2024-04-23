{ config, ... }:
let
  colors = config.colorScheme.palette;
in
{
  programs.i3status-rust = {
    bars = {
      top = {
        blocks = [
          {
            block = "disk_space";
            path = "/";
            info_type = "available";
            interval = 60;
            warning = 30.0;
            alert = 10.0;
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
          }
          {
            block = "cpu";
            interval = 1;
          }
          { block = "battery"; }
          { block = "sound"; }
          { block = "net"; }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %Y-%m-%d %R') ";
          }
        ];
        settings = {
          theme = {
            theme = "ctp-${if config.theming.prefer-dark then "mocha" else "latte"}";
            overrides = with colors; {
              idle_bg = "#${base00}";
              idle_fg = "#${base05}";
              good_bg = "#${base07}";
            };
          };
        };
        icons = "material-nf";
      };
    };
  };
}

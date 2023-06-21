{ ... }:

let catppuccin = {
    mocha = {
      base      = "#1e1e2e";
      mantle    = "#181825";
      surface0  = "#313244";
      surface1  = "#45475a";
      surface2  = "#585b70";
      text      = "#cdd6f4";
      rosewater = "#f5e0dc";
      lavender  = "#b4befe";
      red       = "#f38ba8";
      peach     = "#fab387";
      yellow    = "#f9e2af";
      green     = "#a6e3a1";
      teal      = "#94e2d5";
      blue      = "#89b4fa";
      mauve     = "#cba6f7";
      flamingo  = "#f2cdcd";
    };
  };
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
            warning = 20.0;
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
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %y-%m-%d %R') ";
          }
        ];
        settings = {
          theme =  {
            theme = "solarized-dark";
            overrides = with catppuccin.mocha; {
              idle_bg = base;
              idle_fg = text;
              info_bg = blue;
              info_fg = base;
              good_bg = lavender;
              good_fg = base;
              warning_bg = flamingo;
              warning_fg = base;
              critical_bg = red;
              critical_fg = base;
            };
          };
        };
        icons = "material-nf";
        theme = "solarized-dark";
      };
    };
  };
}

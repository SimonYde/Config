{ ... }:

let catppuccin = {
    mocha = {
      base = "#1e1e2e";
      mantle = "#181825";
      surface0 = "#313244";
      surface1 = "#45475a";
      surface2 = "#585b70";
      text = "#cdd6f4";
      rosewater = "#f5e0dc";
      lavender = "#b4befe";
      red = "#f38ba8";
      peach = "#fab387";
      yellow = "#f9e2af";
      green = "#a6e3a1";
      teal = "#94e2d5";
      blue = "#89b4fa";
      mauve = "#cba6f7";
      flamingo = "#f2cdcd";
    };
  };
in 
{
  xsession.windowManager.i3 = {
  };

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
            overrides = {
              idle_bg = catppuccin.mocha.base;
              idle_fg = catppuccin.mocha.text;
              info_bg = catppuccin.mocha.blue;
              info_fg = catppuccin.mocha.base;
              good_bg = catppuccin.mocha.lavender;
              good_fg = catppuccin.mocha.base;
              warning_bg = catppuccin.mocha.flamingo;
              warning_fg = catppuccin.mocha.base;
              critical_bg = catppuccin.mocha.red;
              critical_fg = catppuccin.mocha.base;
            };
          };
        };
        icons = "material-nf";
        theme = "solarized-dark";
      };
    };
  };
}

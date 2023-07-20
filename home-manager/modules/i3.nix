{ config, lib, pkgs, ... }:

let
  catppuccin = {
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
  terminal = "alacritty";
  browser = "firefox";
  fname = "JetBrains Mono Nerd Font Mono";
  # menu = "${pkgs.bemenu}/bin/bemenu-run -p » --fn 'pango:${fname} ${builtins.toString 10}' --nb '#1e1e2e' --sf '#1e1e2e' --sb '#b4befe'  --nf '#b4befe'";
  menu = "--no-startup-id dmenu_run -nb '${catppuccin.mocha.base}' -sf '${catppuccin.mocha.base}' -sb '${catppuccin.mocha.lavender}' -nf '${catppuccin.mocha.lavender}'";
  volumeChange = 10;
  brightnessChange = 5;
  mod = "Mod4";
in
{
  config = { 
    xsession.windowManager.i3 = {
      config = {
        inherit terminal;
        modifier = mod;

        keybindings = {
# Launch applications
          "${mod}+t" = "exec ${terminal}";
          "${mod}+r" = "mode \"resize\"";
          "ctrl+${mod}+f" = "exec ${browser}";
          "${mod}+d" = "exec ${menu}";
          "${mod}+Escape" = "exec loginctl lock-session";

# Sound
          "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer --allow-boost -i ${toString volumeChange}";
          "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer --allow-boost -d ${toString volumeChange}";
          "XF86AudioMute" = "exec --no-startup-id ${pkgs.pamixer}/bin/pamixer -t";
          # "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pactl}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";


# Brightness
          "XF86MonBrightnessUp" = "exec light -A ${toString brightnessChange}";
          "XF86MonBrightnessDown" = "exec light -U ${toString brightnessChange}";

# Layout
          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

# Window
          "${mod}+q" = "kill";
          "${mod}+f" = "fullscreen";
          "${mod}+Space" = "floating toggle";
          "${mod}+s" = "sticky toggle";

# Scratchpad
          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";


# Focus
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

# Move Window
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

# Switch workspace
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          # Move container to workspace
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          # Sway specific
          "${mod}+Shift+r" = "reload";
          "${mod}+Shift+e" = ''exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"'';
        };

        modes = {
          resize = {
            "h" = "resize shrink width 10px";
            "j" = "resize grow height 10px";
            "k" = "resize shrink height 10px";
            "l" = "resize grow width 10px";
            "Left" = "resize shrink width 10px";
            "Down" = "resize grow height 10px";
            "Up" = "resize shrink height 10px";
            "Right" = "resize grow width 10px";

            # Return to default mode
            "Return" = "mode \"default\"";
            "Escape" = "mode \"default\"";
            "${mod}+r" = "mode \"default\"";
          };
        };

        colors = with catppuccin.mocha; {
          background = base;
          focused = {
            border = lavender;
            background = base;
            text = text;
            indicator = rosewater;
            childBorder = lavender;
          };
          unfocused = {
            border = base;
            background = base;
            text = text;
            indicator = surface1;
            childBorder = base;
          };
          urgent = {
            border = red;
            background = base;
            text = surface0;
            indicator = red;
            childBorder = red;
          };
        };

        bars = [{
          position = "top";
          fonts = {
            names = [ fname "FontAwesome" ];
            size = 8.0;
          };
          statusCommand = "i3status-rs config-top";
          colors = with catppuccin.mocha; {
            background = mantle;
            statusline = text;
            focusedWorkspace = {
              background = lavender;
              border = lavender;
              text = base;
            };
            inactiveWorkspace = {
              background = surface0;
              border = surface0;
              text = surface2;
            };
            urgentWorkspace = {
              background = red;
              border = red;
              text = surface0;
            };
          };
        }];

        floating = {
          criteria = [ { window_role = "pop-up"; } ];
        };

        fonts = {
          names = [ fname ];
          size = 9.0;
        };

        window = {
          titlebar = false;
          border = 3;
        };

        assigns = {
        "1" = [{ class = "obsidian"; }];
        "2" = [{ class = "firefox"; }];
        };

        startup = [
        { command = "${pkgs.xss-lock}/bin/xss-lock --transfer-sleep-lock -- i3lock -e -c 181825 --nofork"; notification = false; }
        { command = "dex --autostart --environment i3"; notification = false; }
        { command = "nm-applet"; notification = false; }
        # { command = "setxkbmap eu"; }
        { command = "${pkgs.feh}/bin/feh --bg-fill ~/Config/assets/backgrounds/battlefield-catppuccin.png"; }
        { command = "redshift"; } 
        { command = "obsidian"; } 
        ];
      };
    };

    programs.i3status-rust = {
      enable = config.xsession.windowManager.i3.enable || config.wayland.windowManager.sway.enable;
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
            format = " $timestamp.datetime(f:'%a %Y-%m-%d %R') ";
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
  };
}

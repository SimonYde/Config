{ pkgs, config, ... }:

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
  # menu = "${pkgs.bemenu}/bin/bemenu-run -p » --fn 'pango:${fname} ${builtins.toString 10}'";
  menu = " dmenu_run -nb '${catppuccin.mocha.mantle}' -sf '${catppuccin.mocha.base}' -sb '${catppuccin.mocha.lavender}' -nf '${catppuccin.mocha.lavender}'";
  left = "m";
  down = "n";
  up = "e";
  right = "i";
  terminal = "alacritty";
  browser = "firefox";
  volumeChange = 10;
  brightnessChange = 5;
  mod = "Mod4";
  fname = "JetBrains Mono Nerd Font Mono";
in
{
  wayland.windowManager.sway = {
    package = null;
    config = {
      modifier = mod;
      inherit terminal menu left down up right;
      keybindings = {
        "${mod}+t" = "exec ${terminal}";
        "${mod}+r" = "mode \"resize\"";
        "ctrl+${mod}+f" = "exec ${browser}";
        "${mod}+d" = "exec ${menu}";
        "${mod}+Shift+s" = "exec ${pkgs.shotman}/bin/shotman -c region -C";
        "${mod}+Escape" = "exec swaylock";

        # Sound
        "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --allow-boost -i ${toString volumeChange}";
        "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --allow-boost -d ${toString volumeChange}";
        "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";
        # "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # Brightness
        "XF86MonBrightnessUp" = "exec light -A ${toString brightnessChange}";
        "XF86MonBrightnessDown" = "exec light -U ${toString brightnessChange}";

        # Layout
        "${mod}+b" = "splith";
        "${mod}+v" = "splitv";
        "${mod}+w" = "layout tabbed";
        "${mod}+s" = "layout toggle split";

        # Window
        "${mod}+q" = "kill";
        "${mod}+f" = "fullscreen";
        "${mod}+mod1+f" = "floating toggle";
        "${mod}+mod1+s" = "sticky toggle";

        # Scratchpad
        "${mod}+Shift+minus" = "move scratchpad";
        "${mod}+minus" = "scratchpad show";

        # Disable laptop screen
        "${mod}+mod1+l" = "output eDP-1 toggle";
        "${mod}+mod1+Space" = "swagmsg input type:keyboard xkb_switch_layout";

        # Focus
        "${mod}+${left}"  = "focus left";
        "${mod}+${down}"  = "focus down";
        "${mod}+${up}"    = "focus up";
        "${mod}+${right}" = "focus right";
        "${mod}+Left" = "focus left";
        "${mod}+Down" = "focus down";
        "${mod}+Up" = "focus up";
        "${mod}+Right" = "focus right";

        # Move Window
        "${mod}+Shift+${left}"  = "move left";
        "${mod}+Shift+${down}"  = "move down";
        "${mod}+Shift+${up}"    = "move up";
        "${mod}+Shift+${right}" = "move right";
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
        "${mod}+Shift+Escape" = ''exec "swaynag -t warning -m 'Exit Sway' -B 'Yes' 'swaymsg exit'"'';
      };

      modes = {
        resize = {
          "${left}"  = "resize shrink width 10px";
          "${down}"  = "resize grow height 10px";
          "${up}"    = "resize shrink height 10px";
          "${right}" = "resize grow width 10px";
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

      defaultWorkspace = "workspace number 1";
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
          names = [ "${fname}" "FontAwesome" ];
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

      gaps = {
        inner = 7;
        outer = 5;
      };

      floating = {
        criteria = [ { window_role = "pop-up"; } ];
      };

      fonts = {
        names = [ "JetBrains Mono Nerd Font Mono" ];
        size = 11.0;
      };

      window = {
        titlebar = false;
        border = 2;
      }; 

      input = {
        "type:keyboard" = {
          # xkb_layout = "eu";
          xkb_layout = "us(colemak_dh),dk";
          xkb_options = "caps:escape,grp:rctrl_toggle";
        };
        "type:touchpad" = {
          dwt              = "enabled";
          tap              = "enabled";
          natural_scroll   = "enabled";
          middle_emulation = "enabled";
        };
      };

      output = {
        "*" = { bg = "~/Config/assets/backgrounds/battlefield-catppuccin.png fill"; };
      };

      assigns = {
      "1" = [{ class = "obsidian"; }];
      "2" = [{ class = "firefox"; }];
      "4" = [{ class = "Brave-browser"; }];
      "5" = [{ class = "VSCodium"; }];
      };


      startup = [
      { command = "obsidian"; }
      # { command = "redshift"; } # This is X-org only, gammastep service instead
      # { command = "nm-applet"; } # nm-applet doesn't work in wayland, TODO: look at alternatives
      ];
    };
  };


  programs.swaylock = {
    enable = config.wayland.windowManager.sway.enable;
    settings = {
      color = catppuccin.mocha.mantle;
      font-size = 24;
      indicator-idle-visible = false;
      ignore-empty-password = true;
      indicator-radius = 100;
      show-failed-attempts = true;
    };
  };
}

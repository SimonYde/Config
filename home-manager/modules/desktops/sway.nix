{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.wayland.windowManager.sway;
  colors = config.colorScheme.palette;
  font = config.syde.theming.fonts.sansSerif;
  menu = "rofi -show drun";
  left = "m";
  down = "n";
  up = "e";
  right = "i";
  terminal = config.syde.terminal.emulator;
  browser = config.syde.browser;
  volumeChange = 10;
  brightnessChange = 5;
  mod = "Mod4";
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      rofi.enable = true;
      swaylock.enable = true;
    };

    wayland.windowManager.sway = {
      package = null; # Let nixos module decide which package to use

      config = {
        modifier = mod;
        defaultWorkspace = "workspace number 1";
        inherit
          terminal
          menu
          left
          down
          up
          right
          ;
        keybindings = {
          "${mod}+t" = "exec ${terminal}";
          "${mod}+r" = "mode \"resize\"";
          "ctrl+${mod}+f" = "exec ${browser}";
          "${mod}+d" = "exec ${menu}";
          "${mod}+Shift+s" = "exec ${pkgs.shotman}/bin/shotman -c region -C";
          "${mod}+Escape" = "exec swaylock";
          "mod1+Space" = "exec ${menu}";

          # Sound
          "XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --allow-boost -i ${toString volumeChange}";
          "XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --allow-boost -d ${toString volumeChange}";
          "XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer -t";

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

          # Focus
          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";
          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          # Move Window
          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
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
            "${left}" = "resize shrink width 30px";
            "${down}" = "resize grow height 30px";
            "${up}" = "resize shrink height 30px";
            "${right}" = "resize grow width 30px";
            "Left" = "resize shrink width 30px";
            "Down" = "resize grow height 30px";
            "Up" = "resize shrink height 30px";
            "Right" = "resize grow width 30px";

            # Return to default mode
            "Return" = "mode \"default\"";
            "Escape" = "mode \"default\"";
            "${mod}+r" = "mode \"default\"";
          };
        };

        colors = with colors; {
          background = base00;
          focused = {
            border = base07;
            background = base00;
            text = base05;
            indicator = base06;
            childBorder = base07;
          };
          unfocused = {
            border = base00;
            background = base00;
            text = base05;
            indicator = base03;
            childBorder = base00;
          };
          urgent = {
            border = base08;
            background = base00;
            text = base02;
            indicator = base08;
            childBorder = base08;
          };
        };

        bars = [
          {
            position = "top";
            command = "waybar";
          }
        ];
        # bars = [{
        #   position = "top";
        #   fonts = {
        #     names = [ font "FontAwesome" ];
        #     size = 8.0;
        #   };
        #   statusCommand = "i3status-rs config-top";
        #   colors = with colors; {
        #     background = base01;
        #     statusline = base05;
        #     focusedWorkspace = {
        #       background = base07;
        #       border = base07;
        #       text = base00;
        #     };
        #     inactiveWorkspace = {
        #       background = base02;
        #       border = base02;
        #       text = base04;
        #     };
        #     urgentWorkspace = {
        #       background = base08;
        #       border = base08;
        #       text = base02;
        #     };
        #   };
        # }];

        gaps = {
          smartGaps = false;
          inner = 5;
          outer = 4;
        };

        floating = {
          criteria = [
            {
              app_id = "firefox";
              title = "Picture-in-Picture";
            }
            { window_role = "pop-up"; }
            { class = "Matplotlib"; }
          ];
        };

        fonts = {
          names = [ font.name ];
          size = 11.0;
        };

        window = {
          titlebar = false;
          border = 1;
        };

        input = {
          "type:keyboard" = {
            xkb_layout = "us(colemak_dh),dk";
            xkb_options = "caps:escape,grp:rctrl_toggle";
          };
          "type:pointer" = {
            accel_profile = "flat";
            pointer_accel = "0.1";
            natural_scroll = "disabled";
          };
          "type:touchpad" = {
            dwt = "enabled";
            tap = "enabled";
            scroll_factor = "0.8";
            natural_scroll = "enabled";
            middle_emulation = "enabled";
          };
        };

        output = {
          "*" = {
            bg = "~/Config/assets/backgrounds/battlefield-catppuccin.png fill";
          };
        };

        assigns = {
          "1" = [ { class = "obsidian"; } ];
          "2" = [
            { class = "firefox"; }
            { app_id = "firefox"; }
          ];
          "4" = [ { class = "Brave-browser"; } ];
          "5" = [ { class = "VSCodium"; } ];
        };

        startup = [
          { command = "${pkgs.autotiling-rs}/bin/autotiling-rs"; }
          {
            command = "nm-applet";
            always = false;
          }
          {
            command = "blueman-applet";
            always = false;
          }
          { command = "obsidian"; }
        ];
      };
    };
  };
}

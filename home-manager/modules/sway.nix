{ pkgs, config, lib, ... }:

let
  flavour = config.themes.flavour;
  catppuccin = config.themes.catppuccin;
  # menu = " dmenu_run -nb '${catppuccin.${theme}.mantle}' -sf '${catppuccin.${theme}.base}' -sb '${catppuccin.${theme}.lavender}' -nf '${catppuccin.${theme}.lavender}'";
  menu = "${pkgs.rofi-wayland}/bin/rofi -show drun";
  left = "m";
  down = "n";
  up = "e";
  right = "i";
  terminal = "alacritty";
  browser = "firefox";
  volumeChange = 10;
  brightnessChange = 5;
  mod = "Mod4";
  font = config.syde.terminal.font;
in
{
  wayland.windowManager.sway = {
    wrapperFeatures.gtk = true;
    wrapperFeatures.base = true;
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

      defaultWorkspace = "workspace number 1";
      colors = with catppuccin.${flavour}; {
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
          names = [ font ];
          size = 8.0;
        };
        statusCommand = "i3status-rs config-top";
        colors = with catppuccin.${flavour}; {
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
        criteria = [{ window_role = "pop-up"; }];
      };

      fonts = {
        names = [ font ];
        size = 11.0;
      };

      window = {
        titlebar = false;
        border = 2;
      };

      input = {
        "type:keyboard" = {
          xkb_layout = "us(colemak_dh),dk";
          xkb_options = "caps:escape,grp:rctrl_toggle";
        };
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
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
      ];
    };
  };


  programs.swaylock = {
    enable = config.wayland.windowManager.sway.enable;
    settings = {
      color = catppuccin.${flavour}.mantle;
      font-size = 24;
      indicator-idle-visible = false;
      ignore-empty-password = true;
      indicator-radius = 100;
      show-failed-attempts = true;
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
          { block = "net"; }
          {
            block = "time";
            interval = 60;
            format = " $timestamp.datetime(f:'%a %Y-%m-%d %R') ";
          }
        ];
        settings = {
          theme = {
            theme = "ctp-${flavour}";
            # theme = "solarized-dark";
            overrides = with catppuccin.${flavour}; {
              idle_bg = base;
              idle_fg = text;
              # info_bg = blue;
              # info_fg = base;
              # good_bg = lavender;
              # good_fg = base;
              # warning_bg = flamingo;
              # warning_fg = base;
              # critical_bg = red;
              # critical_fg = base;
            };
          };
        };
        icons = "material-nf";
      };
    };
  };

  home.file = lib.mkIf (config.wayland.windowManager.sway.enable || config.xsession.windowManager.i3.enable) {
    "${config.xdg.configHome}/rofi/config.rasi".text = ''
      configuration{
        modi: "run,drun";
        icon-theme: "Oranchelo";
        show-icons: true;
        terminal: "alacritty";
        drun-display-format: "{icon} {name}";
        location: 0;
        disable-history: false;
        hide-scrollbar: true;
        display-drun: "   Apps ";
        display-run: "   Run ";
        display-window: "  Window";
        display-Network: " 󰤨  Network"; 
        sidebar-mode: true;
      }
      @theme "catppuccin-${flavour}"
    '';

    "${config.xdg.configHome}/rofi/catppuccin-${flavour}.rasi" = {
      source = (pkgs.fetchFromGitHub {
        owner = "Catppuccin";
        repo = "rofi";
        rev = "5350da4";
        sha256 = "sha256-DNorfyl3C4RBclF2KDgwvQQwixpTwSRu7fIvihPN8JY=";
      }) + "/basic/.local/share/rofi/themes/catppuccin-${flavour}.rasi";
    };
  };
}

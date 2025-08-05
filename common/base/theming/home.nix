{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkForce
    mkOrder
    toHexString
    toLower
    ;
  inherit (config.lib.stylix) colors;
  inherit (config.stylix) opacity fonts;

  hexOpacity = opacity: toLower (toHexString (builtins.ceil (255.0 * opacity)));
  mkRgba =
    opacity: color:
    "rgba(${colors."${color}-rgb-r"},${colors."${color}-rgb-g"},${colors."${color}-rgb-b"},${hexOpacity opacity})";
  mkRgb =
    color: "rgb(${colors."${color}-rgb-r"},${colors."${color}-rgb-g"},${colors."${color}-rgb-b"})";
in
{
  stylix = {
    iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      light = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    targets = {
      firefox.enable = false;
      zen-browser.profileNames = [ config.home.username ];
      gnome.enable = false;
      neovim.enable = false;
      nushell.enable = false;
      neovide.enable = false;
      ncspot.enable = false;
      waybar = {
        font = "sansSerif";
        addCss = false;
      };
      wezterm.enable = false;
      rofi.enable = false;
      zellij.enable = true;
      gnome-text-editor.enable = false;
    };
  };

  # Extra fonts
  home.packages = with pkgs; [
    font-awesome
    gentium
    atkinson-hyperlegible-next
    atkinson-monolegible
    libertinus
    junicode
    newcomputermodern
    roboto
    source-sans-pro
  ];

  home.sessionVariables = {
    HYPRCURSOR_THEME = config.stylix.cursor.name;
    HYPRCURSOR_SIZE = config.stylix.cursor.size;
    GTK_THEME = config.gtk.theme.name;
    WALLPAPER_DIR = "${config.xdg.userDirs.pictures}/wallpapers/${colors.slug}";
  };

  gtk = {
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = colors.variant == "dark";
    gtk4.extraConfig.gtk-application-prefer-dark-theme = colors.variant == "dark";
  };

  programs.ashell.settings.appearance = with colors.withHashtag; {
    font_name = fonts.sansSerif.name;
    opacity = opacity.popups;
    background_color = base00;
    primary_color = base0D;
    secondary_color = base01;
    # used for success message or happy state
    success_color = base0B;
    # used for danger message or danger state (the weak version is used for the warning state
    danger_color = base08;
    # base default text color
    text_color = base05;
    # this is a list of color that will be used in the workspace module (one color for each monitor)
    workspace_colors = [
      base0D
      base0E
    ];
    # this is a list of color that will be used in the workspace module
    # for the special workspace (one color for each monitor)
    # optional, default None
    # without a value the workspaceColors list will be used
    special_workspace_colors = [
      base0B
      base08
    ];

    menu.opacity = opacity.popups;
  };

  programs = {
    anyrun.extraCss =
      # css
      ''
        * {
          all: unset;
          font-size: ${toString fonts.sizes.popups}pt;
          background: ${mkRgba opacity.popups "base00"};
        }

        #window,
        #match,
        #entry,
        #plugin,
        #main {
          background: transparent;
        }

        #match.activatable {
          border-radius: 8px;
          margin: 4px 0;
          padding: 4px;
          /* transition: 100ms ease-out; */
        }
        #match.activatable:first-child {
          margin-top: 12px;
        }
        #match.activatable:last-child {
          margin-bottom: 0;
        }

        #match:hover {
          background: rgba(255, 255, 255, 0.05);
        }
        #match:selected {
          background: rgba(255, 255, 255, 0.1);
        }

        #entry {
          background: rgba(255, 255, 255, 0.05);
          border: 1px solid rgba(255, 255, 255, 0.1);
          border-radius: 8px;
          padding: 4px 8px;
        }

        box#main {
          background: ${mkRgba opacity.popups "base00"};
          box-shadow:
            inset 0 0 0 1px rgba(255, 255, 255, 0.1),
            0 30px 30px 15px rgba(0, 0, 0, 0.5);
          border-radius: 20px;
          padding: 12px;
        }
      '';

    fzf.colors.bg = mkForce "";

    git = {
      difftastic.background = colors.variant;
      delta.options = {
        dark = if colors.variant == "dark" then "true" else "false";
        syntax-theme = "base16-stylix";
      };
    };

    # NOTE: Stylix shouldn't set settings, but generate the theme
    helix.settings = mkForce { };

    hyprlock.settings.label = {
      color = "rgb(${colors.base05})";
      font_family = fonts.sansSerif.name;
    };

    imv.settings.options = with colors; {
      background = base00;
      overlay_background_color = base01;
      overlay_text_color = base05;
    };

    firefox.profiles.${config.home.username}.settings = {
      "font.default.x-western" = "sans-serif";
      "font.name.monospace.x-western" = fonts.monospace.name;
      "font.name.sans-serif.x-western" = fonts.sansSerif.name;
      "font.name.serif.x-western" = fonts.serif.name;
    };

    nushell.extraConfig =
      with colors.withHashtag;
      mkOrder 1000 # nu
        ''
          $env.config.color_config = {
            binary: '${base0E}'
            block: '${base0D}'
            cell-path: '${base05}'
            closure: '${base0C}'
            custom: '${base07}'
            duration: '${base0A}'
            float: '${base08}'
            glob: '${base07}'
            int: '${base09}'
            list: '${base0C}'
            nothing: '${base08}'
            range: '${base0A}'
            record: '${base0C}'
            string: '${base0B}'

            bool: {|| if $in { '${base0C}' } else { '${base0A}' } }

            datetime: {|| (date now) - $in |
              if $in < 1hr {
                { fg: '${base08}' attr: 'b' }
              } else if $in < 6hr {
                '${base08}'
              } else if $in < 1day {
                '${base0A}'
              } else if $in < 3day {
                '${base0B}'
              } else if $in < 1wk {
                { fg: '${base0B}' attr: 'b' }
              } else if $in < 6wk {
                '${base0C}'
              } else if $in < 52wk {
                '${base0D}'
              } else { 'dark_gray' }
            }

            filesize: {|e|
              if $e == 0b {
                '${base05}'
              } else if $e < 1mb {
                '${base0C}'
              } else {{ fg: '${base0D}' }}
            }

            shape_and: { fg: '${base0E}' attr: 'b' }
            shape_binary: { fg: '${base0E}' attr: 'b' }
            shape_block: { fg: '${base0D}' attr: 'b' }
            shape_bool: '${base0C}'
            shape_closure: { fg: '${base0C}' attr: 'b' }
            shape_custom: '${base0B}'
            shape_datetime: { fg: '${base0C}' attr: 'b' }
            shape_directory: '${base0C}'
            shape_external: '${base0C}'
            shape_external_resolved: '${base0C}'
            shape_externalarg: { fg: '${base0B}' attr: 'b' }
            shape_filepath: '${base0C}'
            shape_flag: { fg: '${base0D}' attr: 'b' }
            shape_float: { fg: '${base08}' attr: 'b' }
            shape_garbage: { fg: '${base05}' bg: '${base08}' attr: 'b' }
            shape_glob_interpolation: { fg: '${base0C}' attr: 'b' }
            shape_globpattern: { fg: '${base0C}' attr: 'b' }
            shape_int: { fg: '${base09}' attr: 'b' }
            shape_internalcall: { fg: '${base0C}' attr: 'b' }
            shape_keyword: { fg: '${base0E}' attr: 'b' }
            shape_list: { fg: '${base0C}' attr: 'b' }
            shape_literal: '${base0D}'
            shape_match_pattern: '${base0B}'
            shape_matching_brackets: { attr: 'u' }
            shape_nothing: '${base08}'
            shape_operator: '${base0A}'
            shape_or: { fg: '${base0E}' attr: 'b' }
            shape_pipe: { fg: '${base0E}' attr: 'b' }
            shape_range: { fg: '${base0A}' attr: 'b' }
            shape_raw_string: { fg: '${base07}' attr: 'b' }
            shape_record: { fg: '${base0C}' attr: 'b' }
            shape_redirection: { fg: '${base0E}' attr: 'b' }
            shape_signature: { fg: '${base0B}' attr: 'b' }
            shape_string: '${base0B}'
            shape_string_interpolation: { fg: '${base0C}' attr: 'b' }
            shape_table: { fg: '${base0D}' attr: 'b' }
            shape_vardecl: { fg: '${base0D}' attr: 'u' }
            shape_variable: '${base0E}'

            foreground: '${base05}'
            background: '${base00}'
            cursor: '${base05}'

            empty: '${base0D}'
            header: '${base05}'
            hints: '${base03}'
            leading_trailing_space_bg: { attr: 'n' }
            row_index: { fg: '${base0B}' attr: 'b' }
            search_result: { fg: '${base08}' bg: '${base05}' }
            separator: '${base04}'
          }
        '';

    waybar.style = builtins.readFile ./waybar.css;

    wezterm.colorSchemes.stylix = with colors.withHashtag; {
      ansi = [
        base00
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base05
      ];
      brights = [
        base03
        base08
        base0B
        base0A
        base0D
        base0E
        base0C
        base07
      ];
      background = base00;
      cursor_bg = base05;
      cursor_fg = base00;
      compose_cursor = base06;
      foreground = base05;
      scrollbar_thumb = base01;
      selection_bg = base05;
      selection_fg = base00;
      split = base03;
      visual_bell = base09;
      tab_bar = {
        background = base01;
        inactive_tab_edge = base01;
        active_tab = {
          bg_color = base00;
          fg_color = base05;
        };
        inactive_tab = {
          bg_color = base03;
          fg_color = base05;
        };
        inactive_tab_hover = {
          bg_color = base05;
          fg_color = base00;
        };
        new_tab = {
          bg_color = base03;
          fg_color = base05;
        };
        new_tab_hover = {
          bg_color = base05;
          fg_color = base00;
        };
      };
    };

    wlogout.style =
      with colors.withHashtag;
      let
        icon_path = "${pkgs.wlogout}/share/wlogout/icons";
      in
      # css
      ''
        window {
          font-family: ${fonts.sansSerif.name} Medium;
          background-color: transparent;
          color: ${base05};
        }

        button {
          background-repeat: no-repeat;
          background-position: center;
          background-size: 20%;
          box-shadow: 0 0 0 0;
          background-color: transparent;
          border-color: transparent;
        	text-decoration-color: ${base05};
          color: ${base05};
          border-radius: 36px;
        }

        button:focus, button:active, button:hover {
          background-size: 50%;
          box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
        	background-color: ${base0D};
          color: transparent;
          transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
        }

        #lock {
            background-image: image(url("${icon_path}/lock.png"));
        }

        #logout {
            background-image: image(url("${icon_path}/logout.png"));
        }

        #suspend {
            background-image: image(url("${icon_path}/suspend.png"));
        }

        #hibernate {
            background-image: image(url("${icon_path}/hibernate.png"));
        }

        #poweroff {
            background-image: image(url("${icon_path}/shutdown.png"));
        }

        #reboot {
            background-image: image(url("${icon_path}/reboot.png"));
        }

      '';

    zathura.options = {
      statusbar-fg = mkForce (mkRgb "base05");
    };
  };

  wayland.windowManager.hyprland.settings = with colors; {
    "$opacity_popups" = opacity.popups;
    "$opacity_apps" = opacity.applications;
    general = {
      "col.active_border" = mkForce "rgb(${base0D}) rgb(${base0E}) 45deg";
      "col.inactive_border" = mkForce "rgba(00000000)";
    };

    group.groupbar.text_color = mkForce "rgb(${base00})";
  };

  xdg.configFile."wezterm/stylix.lua".text =
    with colors.withHashtag; # lua
    ''
        return {
          color_scheme = "stylix",
          font_size = ${toString fonts.sizes.terminal},
          window_background_opacity = ${toString opacity.terminal},
          window_frame = {
              active_titlebar_bg = "${base03}",
              active_titlebar_fg = "${base05}",
              active_titlebar_border_bottom = "${base03}",
              border_left_color = "${base01}",
              border_right_color = "${base01}",
              border_bottom_color = "${base01}",
              border_top_color = "${base01}",
              button_bg = "${base01}",
              button_fg = "${base05}",
              button_hover_bg = "${base05}",
              button_hover_fg = "${base03}",
              inactive_titlebar_bg = "${base01}",
              inactive_titlebar_fg = "${base05}",
              inactive_titlebar_border_bottom = "${base03}",
          },
          colors = {
            tab_bar = {
              background = "${base00}",
              inactive_tab_edge = "${base01}",
              active_tab = {
                bg_color = "${base00}",
                fg_color = "${base05}",
              },
              inactive_tab = {
                bg_color = "${base03}",
                fg_color = "${base05}",
              },
              inactive_tab_hover = {
                bg_color = "${base05}",
                fg_color = "${base00}",
              },
              new_tab = {
                bg_color = "${base03}",
                fg_color = "${base05}",
              },
              new_tab_hover = {
                bg_color = "${base05}",
                fg_color = "${base00}",
              },
            },
          },
          command_palette_bg_color = "${base01}",
          command_palette_fg_color = "${base05}",
          command_palette_font_size = ${toString fonts.sizes.popups},
      }
    '';
}

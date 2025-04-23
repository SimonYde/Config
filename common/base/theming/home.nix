{
  pkgs,
  config,
  lib,
  ...
}:

/*
  This module serves to handle stylix and other theming options through home-manager.

  This module assumes stylix has been imported somewhere but is not dependent
  on running NixOS directly.

  I use home-manager on NixOS using the auto-import feature, meaning every
  profile gets the same configuration.
*/

let
  inherit (lib)
    mkForce
    mkIf
    mkMerge
    mkOrder
    toHexString
    toLower
    ;
  inherit (config.lib.stylix) colors;
  inherit (config.stylix) opacity fonts;

  hexOpacity = opacity: toLower (toHexString (builtins.ceil (255.0 * opacity)));
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
      neovim.enable = false;
      nushell.enable = false;
      waybar = {
        font = "sansSerif";
        addCss = false;
      };
      rofi.enable = false;
      zellij.enable = false;
      spicetify.enable = false;
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
    GTK_THEME = config.gtk.theme.name;
    WALLPAPER_DIR = "${config.xdg.userDirs.pictures}/wallpapers/${colors.slug}";
  };

  gtk = {
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    gtk3.extraConfig.gtk-application-prefer-dark-theme = colors.variant == "dark";
    gtk4.extraConfig.gtk-application-prefer-dark-theme = colors.variant == "dark";
  };

  programs = mkMerge [
    {
      fzf.colors.bg = mkForce "";

      git.difftastic.background = colors.variant;

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

      rofi = {
        font = "${fonts.sansSerif.name} ${toString fonts.sizes.popups}";
        theme = "custom_base16";
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

              date: {|| (date now) - $in |
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
              separator: '${base03}'
            }
          '';

      waybar.style = builtins.readFile ./waybar.css;

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
    }

    (mkIf (config.programs ? spicetify) {
      # NOTE: 2025-03-06 Simon Yde, because stylix uses bad colors.
      spicetify = {
        theme = {
          name = "stylix";
          src = pkgs.writeTextFile {
            name = "color.ini";
            destination = "/color.ini";
            text =
              with colors; # ini
              ''
                [base]
                text               = ${base05}
                subtext            = ${base05}
                main               = ${base00}
                main-elevated      = ${base02}
                highlight          = ${base02}
                highlight-elevated = ${base03}
                sidebar            = ${base01}
                player             = ${base05}
                card               = ${base01}
                shadow             = ${base00}
                selected-row       = ${base05}
                button             = ${base05}
                button-active      = ${base05}
                button-disabled    = ${base01}
                tab-active         = ${base02}
                notification       = ${base02}
                notification-error = ${base08}
                equalizer          = ${base0B}
                misc               = ${base02}
              '';
          };
          # Sidebar configuration is incompatible with the default navigation bar
          sidebarConfig = false;
        };
        colorScheme = "base";
      };
    })
  ];

  wayland.windowManager.hyprland.settings = with colors; {
    general = {
      "col.active_border" = mkForce "rgb(${base0D}) rgb(${base0E}) 45deg";
      "col.inactive_border" = mkForce "rgba(00000000)";
    };

    group.groupbar.text_color = mkForce "rgb(${base00})";
  };

  xdg.configFile = {
    "rofi/custom_base16.rasi" = {
      inherit (config.programs.rofi) enable;
      text =
        with colors.withHashtag;
        ''
          * {
              bg: ${base00}${hexOpacity opacity.popups};
              bg-col: ${base00}00;
              bg-col-light: ${base00}00;
              border-col: ${base00}00;
              selected-col: ${base00}00;
              blue: ${base0D};
              fg-col: ${base05};
              fg-col2: ${base08};
              grey: ${base04};
              width: 600;
          }
        ''
        + builtins.readFile ./rofi.rasi;
    };

    "zellij/themes/base16-custom.kdl" = {
      inherit (config.programs.zellij) enable;
      text =
        with colors.withHashtag; # kdl
        ''
          themes {
            base16-custom {
              bg "${base02}"
              fg "${base05}"
              red "${base08}"
              green "${base0D}"
              blue "${base0D}"
              yellow "${base0A}"
              magenta "${base0E}"
              orange "${base09}"
              cyan "${base0C}"
              black "${base01}"
              white "${base05}"
            }
          }
        '';
    };

    "zellij/layouts/compact_zjstatus.kdl" = {
      inherit (config.programs.zellij) enable;
      text =
        with colors.withHashtag; # kdl
        ''
          layout {
            default_tab_template {
              pane size=1 borderless=true {
                plugin location="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm" {
                  format_left   "{mode}#[bg=${base00}] {tabs}"
                  format_center ""
                  format_right  "#[bg=${base00},fg=${base0D}]#[bg=${base0D},fg=${base01},bold] #[bg=${base02},fg=${base05},bold] {session} #[bg=${base03},fg=${base05},bold]"
                  format_space  ""
                  format_hide_on_overlength "true"
                  format_precedence "crl"
                  hide_frame_for_single_pane "false"

                  border_enabled  "false"
                  border_char     "─"
                  border_format   "#[fg=${base05}]{char}"
                  border_position "top"

                  mode_normal        "#[bg=${base0B},fg=${base02},bold] NORMAL#[bg=${base03},fg=${base0B}]█"
                  mode_locked        "#[bg=${base04},fg=${base02},bold] LOCKED #[bg=${base03},fg=${base04}]█"
                  mode_resize        "#[bg=${base08},fg=${base02},bold] RESIZE#[bg=${base03},fg=${base08}]█"
                  mode_pane          "#[bg=${base0D},fg=${base02},bold] PANE#[bg=${base03},fg=${base0D}]█"
                  mode_tab           "#[bg=${base07},fg=${base02},bold] TAB#[bg=${base03},fg=${base07}]█"
                  mode_scroll        "#[bg=${base0A},fg=${base02},bold] SCROLL#[bg=${base03},fg=${base0A}]█"
                  mode_enter_search  "#[bg=${base0D},fg=${base02},bold] ENT-SEARCH#[bg=${base03},fg=${base0D}]█"
                  mode_search        "#[bg=${base0D},fg=${base02},bold] SEARCHARCH#[bg=${base03},fg=${base0D}]█"
                  mode_rename_tab    "#[bg=${base07},fg=${base02},bold] RENAME-TAB#[bg=${base03},fg=${base07}]█"
                  mode_rename_pane   "#[bg=${base0D},fg=${base02},bold] RENAME-PANE#[bg=${base03},fg=${base0D}]█"
                  mode_session       "#[bg=${base0E},fg=${base02},bold] SESSION#[bg=${base03},fg=${base0E}]█"
                  mode_move          "#[bg=${base0F},fg=${base02},bold] MOVE#[bg=${base03},fg=${base0F}]█"
                  mode_prompt        "#[bg=${base0D},fg=${base02},bold] PROMPT#[bg=${base03},fg=${base0D}]█"
                  mode_tmux          "#[bg=${base09},fg=${base02},bold] TMUX#[bg=${base03},fg=${base09}]█"

                  // formatting for inactive tabs
                  tab_normal              "#[bg=${base0D},fg=${base02}]█#[bg=${base02},fg=${base0D},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{floating_indicator}#[bg=${base03},fg=${base02},bold]█"
                  tab_normal_fullscreen   "#[bg=${base0D},fg=${base02}]█#[bg=${base02},fg=${base0D},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{fullscreen_indicator}#[bg=${base03},fg=${base02},bold]█"
                  tab_normal_sync         "#[bg=${base0D},fg=${base02}]█#[bg=${base02},fg=${base0D},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{sync_indicator}#[bg=${base03},fg=${base02},bold]█"

                  // formatting for the current active tab
                  tab_active              "#[bg=${base02},fg=${base0D}]█#[bg=${base0D},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{floating_indicator}#[bg=${base03},fg=${base02},bold]█"
                  tab_active_fullscreen   "#[bg=${base02},fg=${base0D}]█#[bg=${base0D},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{fullscreen_indicator}#[bg=${base03},fg=${base02},bold]█"
                  tab_active_sync         "#[bg=${base02},fg=${base0D}]█#[bg=${base0D},fg=${base02},bold]{index} #[bg=${base02},fg=${base05},bold] {name}{sync_indicator}#[bg=${base03},fg=${base02},bold]█"

                  // separator between the tabs
                  tab_separator           "#[bg=${base00}] "

                  // indicators
                  tab_sync_indicator       " "
                  tab_fullscreen_indicator " 󰊓"
                  tab_floating_indicator   " 󰹙"

                  command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                  command_git_branch_format      "#[fg=blue] {stdout} "
                  command_git_branch_interval    "10"
                  command_git_branch_rendermode  "static"

                  datetime        "#[fg={base05},bold] {format} "
                  datetime_format "%A, %d %b %Y %H:%M"
                  datetime_timezone "Europe/Copenhagen"
                }
              }
              children
              pane size=1 borderless=true {
                plugin location="zellij:status-bar"
              }
            }
          }
        '';
    };
  };
}

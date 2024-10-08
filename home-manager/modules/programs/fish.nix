{
  pkgs,
  config,
  lib,
  ...
}:
let
  palette = config.colorScheme.palette;
  cfg = config.programs.fish;
in
{
  config = lib.mkIf cfg.enable {
    programs.fish = {
      shellInit = # fish
        ''
          ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
          set fish_greeting ""
          fish_config theme choose base16_custom
          # Emulates vim's cursor shape behavior
          # Set the normal and visual mode cursors to a block
          set fish_cursor_default block
          # Set the insert mode cursor to a line
          set fish_cursor_insert line
          # Set the replace mode cursors to an underscore
          set fish_cursor_replace_one underscore
          set fish_cursor_replace underscore
          # Set the external cursor to a line. The external cursor appears when a command is started.
          # The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
          set fish_cursor_external line
          # The following variable can be used to configure cursor shape in
          # visual mode, but due to fish_cursor_default, is redundant here
          set fish_cursor_visual block
        '';

      functions = {
        fish_user_key_bindings = # fish
          ''
            # Execute this once per mode that emacs bindings should be used in
            fish_default_key_bindings -M insert

            # Then execute the vi-bindings so they take precedence when there's a conflict.
            # Without --no-erase fish_vi_key_bindings will default to
            # resetting all bindings.
            # The argument specifies the initial mode (insert, "default" or visual).
            fish_vi_key_bindings --no-erase insert
          '';
      };
    };

    home.file."${config.xdg.configHome}/fish/themes/base16_custom.theme" = {
      text = with palette; ''
        fish_color_autosuggestion ${base04}
        fish_color_cancel ${base08}
        fish_color_command ${base0D}
        fish_color_comment ${base04}
        fish_color_cwd ${base0A}
        fish_color_end ${base09}
        fish_color_error ${base08}
        fish_color_escape ${base0C}
        fish_color_gray ${base03}
        fish_color_host ${base0D}
        fish_color_host_remote ${base0B}
        fish_color_keyword ${base08}
        fish_color_normal ${base05}
        fish_color_operator ${base0E}
        fish_color_option ${base0B}
        fish_color_param ${base0C}
        fish_color_quote ${base0B}
        fish_color_redirection ${base0E}
        fish_color_search_match --background=${base02}
        fish_color_selection --background=${base02}
        fish_color_status ${base08}
        fish_color_user ${base0C}
        fish_pager_color_completion ${base05}
        fish_pager_color_description ${base04}
        fish_pager_color_prefix ${base0E}
        fish_pager_color_progress ${base04}
      '';
    };
  };
}

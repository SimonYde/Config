{
  pkgs,
  config,
  lib,
  ...
}:
let
  colors = config.colorScheme.palette;
  cfg = config.programs.fish;
in
{
  config = lib.mkIf cfg.enable {
    programs.fish = {
      shellInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish | source
        set fish_greeting ""
        fish_config theme choose base16_custom
      '';
    };

    home.file."${config.xdg.configHome}/fish/themes/base16_custom.theme" = {
      text = with colors; ''
        fish_color_autosuggestion ${base04}
        fish_color_cancel ${base08}
        fish_color_command ${base0D}
        fish_color_comment ${base04}
        fish_color_cwd ${base0A}
        fish_color_end ${base09}
        fish_color_error ${base08}
        fish_color_escape ${base0F}
        fish_color_gray ${base03}
        fish_color_host ${base0D}
        fish_color_host_remote ${base0B}
        fish_color_keyword ${base08}
        fish_color_normal ${base05}
        fish_color_operator ${base0E}
        fish_color_option ${base0B}
        fish_color_param ${base0F}
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

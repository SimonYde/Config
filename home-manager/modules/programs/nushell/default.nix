{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
  plugins = with pkgs.nushellPlugins; [
    skim
    formats
    gstat
    query
    formats
  ];
  cfg = config.programs.nushell;
in
{
  config = mkIf cfg.enable {

    home.packages =
      with pkgs;
      [
        nufmt
        nu_scripts
      ]
      ++ plugins;

    programs.carapace.enable = true;
    services.pueue.enable = true; # Background jobs

    programs.nushell = {
      shellAliases = {
        ll = "ls -l";
        la = "ls -a";
        lla = "ls -la";
        lt = "${getExe pkgs.eza} --tree --level=2 --long --icons --git";
      };
      environmentVariables = {
        PROMPT_INDICATOR = "";
        PROMPT_INDICATOR_VI_INSERT = "";
        PROMPT_INDICATOR_VI_NORMAL = "";
        PROMPT_MULTILINE_INDICATOR = "";
        PROMPT_COMMAND = lib.hm.nushell.mkNushellInline ''{|| "> "}'';
      };
      plugins = plugins;
      configFile.source = ./config.nu;
      extraConfig =
        with config.syde.theming.palette-hex;
        let
          nu_scripts = "${pkgs.nu_scripts}/share/nu_scripts";
        in
        # nu
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

          # use ${nu_scripts}/modules/background_task/task.nu
        '';
    };
  };
}

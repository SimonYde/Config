{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  plugins = with pkgs.nushellPlugins; [
    skim
  ];
  cfg = config.programs.nushell;
in
{
  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      nufmt
    ] ++ plugins;

    programs.neovim.plugins = with pkgs.vimPlugins; [
      nvim-nu
    ];

    programs.carapace.enable = true;
    programs.starship.settings.character.format = lib.mkForce "\n\n";
    programs.starship.enableFishIntegration = lib.mkForce false;
    services.pueue.enable = true; # Background jobs

    programs.nushell = {
      configFile.source = ./config.nu;
      extraConfig =
        with config.syde.theming.palette-hex; # nu
        ''
          $env.config.color_config = {
            separator: "${base03}"
            leading_trailing_space_bg: "${base04}"
            header: "${base05}"
            date: "${base0E}"
            filesize: "${base0D}"
            row_index: "${base0C}"
            bool: "${base09}"
            int: "${base09}"
            duration: "${base08}"
            range: "${base08}"
            float: "${base08}"
            string: "${base0B}"
            nothing: "${base08}"
            binary: "${base08}"
            cellpath: "${base08}"
            hints: dark_gray

            shape_garbage: { fg: "${base07}" bg: "${base08}" }
            shape_bool: "${base09}"
            shape_int: { fg: "${base0E}" attr: b }
            shape_float: { fg: "${base0E}" attr: b }
            shape_range: { fg: "${base0A}" attr: b }
            shape_internalcall: { fg: "${base0C}" attr: b }
            shape_external: "${base0C}"
            shape_externalarg: { fg: "${base0B}" attr: b }
            shape_literal: "${base0D}"
            shape_operator: "${base0A}"
            shape_signature: { fg: "${base0B}" attr: b }
            shape_string: "${base0B}"
            shape_filepath: "${base0D}"
            shape_globpattern: { fg: "${base0D}" attr: b }
            shape_variable: "${base0E}"
            shape_flag: { fg: "${base0D}" attr: b }
            shape_custom: { attr: b }
          }
        '';
    };

    home.file."${config.xdg.configHome}/nushell/plugin.msgpackz" =
      let
        pluginExprs = map (plugin: "plugin add ${lib.getExe plugin}") plugins;
      in
      mkIf (plugins != [ ]) {
        source = pkgs.runCommandLocal "plugin.msgpackz" { } ''
          touch $out {config,env}.nu

          ${lib.getExe cfg.package} \
          --config config.nu \
          --env-config env.nu \
          --plugin-config plugin.msgpackz \
          --no-history \
          --no-std-lib \
          --commands '${lib.concatStringsSep ";" pluginExprs};'

          cp plugin.msgpackz $out
        '';
      };
  };
}

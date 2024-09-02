{ config, lib, ... }:
let
  cfg = config.programs.starship;
in

{
  config = lib.mkIf cfg.enable {
    programs.starship = {
      enableNushellIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      settings = with config.syde.theming.palette-hex; {
        add_newline = false;
        format = ''$username$hostname$directory$nix_shell$git_branch$line_break$character'';
        right_format = "$cmd_duration$rust$elm$golang$ocaml$java$scala$lua$typst$direnv";
        character = {
          success_symbol = "[⟩](normal ${base05})";
          error_symbol = "[⟩](bold ${base08})";
        };
        directory = {
          style = "bold ${base0B}";
          fish_style_pwd_dir_length = 1;
        };
        git_branch = {
          symbol = " ";
          style = "bold ${base0E}";
        };
        git_status = {
          style = "bold ${base0E}";
        };
        hostname = {
          ssh_symbol = "🌐";
        };
        nix_shell = {
          symbol = " ";
          unknown_msg = "nix shell";
          heuristic = false;
          style = "bold ${base0D}";
        };
        golang = {
          symbol = " ";
          style = "bold ${base0C}";
        };
        elm = {
          symbol = " ";
          style = "bold ${base0C}";
        };
        scala = {
          symbol = " ";
          disabled = true;
        };
      };
    };
  };
}

{ config, lib, ... }:
let
  inherit (lib) mapAttrs' nameValuePair toLower;
in
{
  programs.starship = {
    enableNushellIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      palette = "custom_base16";
      add_newline = false;
      format = ''$username$hostname$directory$nix_shell$git_branch$git_status$line_break$character'';
      right_format = "$cmd_duration$rust$elm$golang$ocaml$java$scala$lua$typst$direnv";
      character = {
        success_symbol = "[⟩](normal base05)";
        error_symbol = "[⟩](bold base08)";
      };
      directory = {
        style = "bold base0b";
        fish_style_pwd_dir_length = 1;
      };
      git_branch = {
        symbol = " ";
        style = "bold base0e";
      };
      git_status = {
        style = "bold base0e";
      };
      hostname = {
        ssh_symbol = "🌐";
      };
      nix_shell = {
        symbol = " ";
        unknown_msg = "nix shell";
        heuristic = false;
        style = "bold base0d";
      };
      golang = {
        symbol = " ";
        style = "bold base0c";
      };
      elm = {
        symbol = " ";
        style = "bold base0c";
      };
      palettes.custom_base16 = mapAttrs' (
        name: value: nameValuePair (toLower name) ("#" + value)
      ) config.colorScheme.palette;
    };
  };
}

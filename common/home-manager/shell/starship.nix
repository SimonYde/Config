{ lib, ... }:
let
  inherit (lib) concatStrings;
in
{
  programs.starship.settings = {
    add_newline = false;

    format = concatStrings [
      "$username"
      "$hostname"
      "$directory"
      "$nix_shell"
      "$git_branch"
      "$line_break"
      "$character"
    ];

    right_format = concatStrings [
      "$cmd_duration"
      "$rust"
      "$elm"
      "$golang"
      "$ocaml"
      "$java"
      "$scala"
      "$lua"
      "$typst"
      "$direnv"
      "$gleam"
    ];

    # Modules
    character = {
      format = "$symbol";
      success_symbol = "[⟩](normal white)";
      error_symbol = "[⟩](bold red)";
      # success_symbol = "";
      # error_symbol = "";
    };

    direnv = {
      format = "[($loaded/$allowed)]($style)";
      disabled = false;
      loaded_msg = "";
      allowed_msg = "";
    };

    directory = {
      style = "bold green";
      fish_style_pwd_dir_length = 1;
    };

    git_branch = {
      symbol = " ";
      style = "bold purple";
    };

    git_status = {
      style = "bold purple";
    };

    hostname = {
      ssh_only = false;
      ssh_symbol = "🌐";
    };

    nix_shell = {
      symbol = " ";
      style = "bold blue";
      heuristic = false;
    };

    golang = {
      symbol = " ";
    };

    elm = {
      symbol = " ";
    };

    scala = {
      disabled = true;
      symbol = " ";
    };
  };
}

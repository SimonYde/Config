{...}: {
  programs.starship = {
    enableNushellIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = ''$username$hostname$directory$nix_shell$git_branch$git_status$line_break$character'';
      right_format = "$cmd_duration$rust$elm$golang$ocaml$java$scala$lua$typst$direnv";
      character = {
        success_symbol = "[⟩](normal white)";
        error_symbol = "[⟩](bold red)";
      };
      directory = {
        style = "bold green";
        fish_style_pwd_dir_length = 1;
      };
      git_branch = {
        symbol = " ";
        style = "bold yellow";
      };
      git_status = {
        style = "bold yellow";
      };
      hostname = {
        ssh_symbol = "🌐";
      };
      nix_shell = {
        symbol = " ";
        unknown_msg = "nix shell";
        heuristic = false;
      };
      golang = {
        symbol = " ";
        style = "bold cyan";
      };
      elm = {
        symbol = " ";
        style = "bold cyan";
      };
    };
  };
}

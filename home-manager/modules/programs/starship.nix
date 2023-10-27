{ ... }:

{
  programs.starship = {
    enableNushellIntegration = true;
    enableFishIntegration    = true;
    enableZshIntegration     = true;
    enableBashIntegration    = true;
    settings = {
      add_newline = false;
      format = "$directory$nix_shell$git_branch$line_break$character";
      character = {
        success_symbol = "[⟩](normal white)";
        error_symbol = "[⟩](bold red)";
      };
      directory = {
        style = "bold green";
        fish_style_pwd_dir_length = 1;
      };
      git_branch = {
        style = "bold yellow";
      };
      nix_shell = {
        unknown_msg = "nix shell";
        heuristic = false;
      };
    };
  };
}

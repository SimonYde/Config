{config, pkgs, ... }:

{
  programs.starship = {
    enableNushellIntegration = true;
    enableFishIntegration    = true;
    enableZshIntegration     = true;
    enableBashIntegration    = true;
    settings = {
      add_newline = false;
      format = "$directory$nix_shell$git_branch〉";
      directory = {
        style = "bold green";
        fish_style_pwd_dir_length = 1;
      };
      git_branch = {
        style = "bold yellow";
      };
    };    
  };
}

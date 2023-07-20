{ pkgs,  ... }:

{
  programs.zsh = {
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
    history = {
      ignorePatterns = [ "pkill *" "kill *" "rm *" "rmdir *" "mkdir *" "touch *" ];
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.zsh-nix-shell;
      }
      {
        name = "zsh-completions";
        file = "zsh-completions.plugin.zsh";
        src = pkgs.zsh-completions;
      }
    ];
    initExtra = "
      # Edit current command in editor
      autoload -U edit-command-line; zle -N edit-command-line
      bindkey '^[e' edit-command-line
      # Case insensitive
      zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    ";
  };
}

{ pkgs,  ... }:

{
  programs.zsh = {
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    autocd = true;
    dotDir = ".config/zsh";
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
    initExtra = "
      # Edit current command in editor
      autoload -U edit-command-line; zle -N edit-command-line
      bindkey '^e' edit-command-line
      # Case insensitive
      zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
    ";
  };
}

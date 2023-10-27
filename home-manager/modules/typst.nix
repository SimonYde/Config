{lib, config, pkgs, ...}:

{
  config = lib.mkIf config.syde.programming.typst.enable {
    home.packages = with pkgs; [
      unstable.typst-lsp
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      (pkgs.vimUtils.buildVimPlugin {
        pname = "typst-vim";
        version = "1";
        src = pkgs.fetchFromGitHub {
          owner = "kaarmu";
          repo = "typst.vim";
          rev = "65f9e78c11829a643d1539f3481c0ff875c83603";
          sha256 = "sha256-G5+LX3rg5N9tBBt3i+2phbgfJd97bcxQveVzRegZu+A=";
        };
      })
    ];
  };

  options.syde.programming.typst = with lib; {
    enable = mkEnableOption "Typst" // {
      default = false; 
    };
  };
}


{ config, pkgs, ...}:
let unstablePlugins = pkgs.unstable.vimPlugins; in
{
  config = {
    programs.neovim = {
      package = pkgs.unstable.neovim-unwrapped;
      vimAlias = true;
      extraConfig = ''
        set runtimepath^=${config.home.homeDirectory}/.config/nvim
        lua require('syde')
      '';
      plugins = with pkgs.vimPlugins; [
        
        # LSP
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        # cmp-buffer
        cmp-path
        cmp-snippy
        cmp-nvim-lua
        nvim-snippy
        vim-gitgutter
        unstablePlugins.vim-be-good
        harpoon        
        lexima-vim
        undotree
        vim-fugitive
        which-key-nvim

        # Fuzzy Finder
        unstablePlugins.telescope-nvim
        unstablePlugins.plenary-nvim
        (unstablePlugins.nvim-treesitter.withPlugins(_: unstablePlugins.nvim-treesitter.allGrammars))
        unstablePlugins.nvim-treesitter-textobjects
        lualine-nvim
        indent-blankline-nvim
        vim-nix
        unstablePlugins.neo-tree-nvim
        (pkgs.vimUtils.buildVimPlugin {
          name = "monokai-pro.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "loctvl842";
            repo = "monokai-pro.nvim";
            rev = "42e92960a334c36cf588f096b5821bc63c98293d";
            sha256 = "ElEWoIwcTo0h+dpFvUDejGEkYXsX4oXwmtIRe3g+KvQ=";
          };
        })  
      ];
    };
  };
}

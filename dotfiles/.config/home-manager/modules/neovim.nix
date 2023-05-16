{ config, pkgs, ...}:
let 
  unstablePlugins = pkgs.unstable.vimPlugins; 
in
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
        vim-commentary
        # LSP
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        # cmp-buffer
        cmp-path
        cmp-snippy
        cmp-nvim-lua
        lspsaga-nvim
        nvim-snippy


        harpoon        
        lexima-vim
        undotree
        vim-fugitive
        gitsigns-nvim

        which-key-nvim
        unstablePlugins.vim-be-good

        # Fuzzy Finder
        unstablePlugins.telescope-nvim
        unstablePlugins.plenary-nvim

        # Language plugins
        # (unstablePlugins.nvim-treesitter.withPlugins(_: unstablePlugins.nvim-treesitter.allGrammars))
        unstablePlugins.nvim-treesitter.withAllGrammars
        unstablePlugins.nvim-treesitter-textobjects
        vim-nix

        # UI
        lualine-nvim
        indent-blankline-nvim
        nvim-web-devicons
        neo-tree-nvim
        nui-nvim
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

{ config, pkgs, ... }:
let
  unstablePlugins = pkgs.unstable.vimPlugins;
in
{
  programs.neovim = {
    # package = pkgs.unstable.neovim-unwrapped;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # -----LSP-----
      nvim-lspconfig
      lspkind-nvim
      unstablePlugins.lspsaga-nvim
      fidget-nvim
      nvim-cmp
      cmp-cmdline
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp_luasnip
      luasnip
      copilot-lua

      # -----Workflow-----
      harpoon
      undotree
      gitsigns-nvim
      neogit
      diffview-nvim
      git-worktree-nvim

      mini-nvim
      vim-be-good
      vim-startuptime

      # -----Fuzzy Finder-----
      unstablePlugins.telescope-nvim
      unstablePlugins.telescope-fzf-native-nvim
      unstablePlugins.plenary-nvim

      # -----Highlighting-----
      unstablePlugins.nvim-treesitter.withAllGrammars
      unstablePlugins.nvim-treesitter-textobjects
      unstablePlugins.nvim-treesitter-context
      unstablePlugins.rainbow-delimiters-nvim

      # -----Language extras-----
      # ltex_extra-nvim
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


      # -----UI-----
      which-key-nvim
      trouble-nvim
      lualine-nvim
      indent-blankline-nvim
      nvim-web-devicons
      nvim-tree-lua
      nui-nvim
      unstablePlugins.catppuccin-nvim
    ];
    extraLuaConfig = ''
      vim.loader.enable()
      require('syde')
      require("catppuccin").setup({
        flavour = "${config.themes.flavour}",
        integrations = {
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          -- treesitter_context = true,
          rainbow_delimiters = true,
          -- fidget = true, -- is ugly
          harpoon = true,
          lsp_saga = true,
          telescope = {
             enabled = true,
             style = "nvchad",
          },
          which_key = true,
        },
      })
      vim.cmd.colorscheme "catppuccin"
    '';

  };
  # home.file."${config.xdg.configHome}/nvim/after/plugin/colorscheme.lua".text = ''
  # '';
}

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
    extraConfig = ''
      set runtimepath^=${config.home.homeDirectory}/.config/nvim
      lua require('syde')
    '';
    plugins = with pkgs.vimPlugins; [
      # -----LSP-----
      nvim-lspconfig
      lspkind-nvim
      lspsaga-nvim-original
      nvim-cmp
      cmp-cmdline
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp_luasnip
      luasnip
      fidget-nvim
      copilot-lua

      # -----Workflow-----
      harpoon
      nvim-autopairs
      undotree
      # vim-fugitive
      gitsigns-nvim
      neogit
      git-worktree-nvim
      nvim-surround
      comment-nvim

      vim-be-good

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
      ltex_extra-nvim

      # -----UI-----
      which-key-nvim
      diffview-nvim
      trouble-nvim
      lualine-nvim
      indent-blankline-nvim
      nvim-web-devicons
      nvim-tree-lua
      nui-nvim
      unstablePlugins.catppuccin-nvim
    ];
    extraLuaConfig = ''
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
}

{ config, pkgs, lib, ... }:
let
  unstablePlugins = pkgs.unstable.vimPlugins;
  cfg = config.programs.neovim;
in
{
  programs.neovim = {
    # package = pkgs.unstable.neovim-unwrapped;
    package = pkgs.neovim-nightly;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # -----LSP-----
      unstablePlugins.nvim-lspconfig
      unstablePlugins.lspsaga-nvim
      fidget-nvim

      # nvim-cmp # Temporarily disabled due to upstream bug
      (pkgs.neovimUtils.buildNeovimPluginFrom2Nix {
        pname = "nvim-cmp";
        version = "2023-10-25";
        src = pkgs.fetchFromGitHub {
          owner = "hrsh7th";
          repo = "nvim-cmp";
          rev = "51260c02a8ffded8e16162dcf41a23ec90cfba62";
          sha256 = "sha256-f+ZpSOhBNHW5SgPFQ1ciJnv5Ntm5tX3CErlvMvREtkA=";
        };
      })
      cmp-cmdline
      lspkind-nvim
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp_luasnip
      luasnip
      unstablePlugins.friendly-snippets
      copilot-lua
      unstablePlugins.neodev-nvim

      # -----Workflow-----
      unstablePlugins.harpoon # Stable version is broken for Neovim Nightly
      gitsigns-nvim
      neogit
      diffview-nvim
      unstablePlugins.mini-nvim
      vim-be-good

      # -----Fuzzy Finder-----
      # unstablePlugins.telescope-nvim
      unstablePlugins.plenary-nvim
      # telescope-fzf-native-nvim
      # git-worktree-nvim
      # telescope-undo-nvim

      # -----Highlighting-----
      unstablePlugins.nvim-treesitter.withAllGrammars
      unstablePlugins.nvim-treesitter-textobjects
      unstablePlugins.nvim-treesitter-context
      unstablePlugins.rainbow-delimiters-nvim

      # -----UI-----
      # which-key-nvim
      trouble-nvim
      unstablePlugins.indent-blankline-nvim
      unstablePlugins.nvim-web-devicons
      # nvim-tree-lua
      nui-nvim
      unstablePlugins.catppuccin-nvim
    ];
    extraLuaConfig = ''
      vim.loader.enable()
      require('syde')
      require("catppuccin").setup {
        flavour = "${config.themes.flavour}",
        integrations = {
          indent_blankline = {
            enabled = true,
            colored_indent_levels = false,
          },
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          mini = true,
          treesitter = true,
          treesitter_context = false, -- is ugly
          rainbow_delimiters = true,
          fidget = false, -- is ugly
          harpoon = true,
          lsp_saga = true,
          telescope = {
             enabled = true,
             style = "nvchad",
          },
          which_key = false,
        },
      }
      vim.cmd.colorscheme "catppuccin"
    '';
  };

  home.packages = with pkgs; lib.mkIf cfg.enable [
    nodejs-slim_20 # for copilot.lua
  ];
}

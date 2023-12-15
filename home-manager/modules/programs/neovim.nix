{ config, pkgs, ... }:

{
  programs.neovim = {
    package = pkgs.neovim-nightly;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # -----LSP-----
      nvim-lspconfig
      lspsaga-nvim
      lspkind-nvim
      fidget-nvim

      nvim-cmp
      cmp-cmdline
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp_luasnip
      luasnip
      friendly-snippets
      copilot-lua
      neodev-nvim

      # -----Workflow-----
      harpoon # to have breaking changes
      nvim-autopairs
      gitsigns-nvim
      neogit
      diffview-nvim
      # undotree
      mini-nvim
      vim-be-good

      (pkgs.vimUtils.buildVimPlugin {
        pname = "gen-nvim";
        version = "unstable-2023-11-25";
        src = pkgs.fetchFromGitHub {
          owner = "David-Kunz";
          repo = "gen.nvim";
          rev = "049ec32f337fac6573221cde4f1dd88fa0b31390";
          hash = "sha256-ewKmR0KxaRvk6WqGTGC0ewrdFcHdJeVsdpwi6ga9viQ=";
        };
      })

      # -----Fuzzy Finder-----
      plenary-nvim
      # telescope-nvim
      # telescope-fzf-native-nvim
      # git-worktree-nvim
      # telescope-undo-nvim

      # -----Highlighting-----
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-context
      rainbow-delimiters-nvim

      (pkgs.vimUtils.buildVimPlugin {
        pname = "dolphin-vim";
        version = "2021-11-01";
        src = pkgs.fetchFromGitLab {
          owner = "jo1gi";
          repo = "dolphin-vim";
          rev = "1bddf3c798cbb425f0a288c1a3640e06bea2fccc";
          hash = "sha256-28fPWSYOHyBLiwVkGyYoslpWnqrBFozaSnhFNQ8NG9o=";
        };
      })

      # -----UI-----
      which-key-nvim
      trouble-nvim
      indent-blankline-nvim
      nvim-web-devicons
      nui-nvim
      catppuccin-nvim
    ];
    extraLuaConfig = ''
      vim.loader.enable()
      require('syde')
      require("catppuccin").setup {
        flavour = "${config.themes.flavour}",
        transparent_background = true,
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
          treesitter_context = true, -- is ugly unless transparent_background = true
          rainbow_delimiters = true,
          harpoon = true,
          lsp_saga = true,
          telescope = {
             enabled = true,
             style = "nvchad",
          },
          which_key = true,
        },
        custom_highlights = function(colors)
          return {
            MiniJump = { fg = colors.subtext1, bg = colors.surface2 },
            MiniStatuslineModeNormal = { fg = colors.mantle, bg = colors.lavender, style = {"bold" } },
          }
        end,
      }
      vim.cmd.colorscheme "catppuccin"
    '';
    extraPackages = with pkgs; [
      nodejs-slim_20 # For github copilot
    ];
  };
}

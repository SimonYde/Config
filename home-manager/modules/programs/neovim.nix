{ config, pkgs, ... }:

{
  programs.neovim = {
    package = pkgs.neovim-nightly;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    plugins = with pkgs.vimPlugins; [
      # -----LSP-----
      nvim-lspconfig
      lspsaga-nvim
      lspkind-nvim
      # fidget-nvim

      nvim-cmp
      cmp-cmdline
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      cmp_luasnip
      cmp-nvim-lsp-signature-help
      luasnip
      friendly-snippets
      copilot-lua
      neodev-nvim

      # -----Workflow-----
      harpoon2
      nvim-autopairs
      gitsigns-nvim
      neogit
      diffview-nvim
      mini-nvim
      vim-be-good
      vim-table-mode
      obsidian-nvim

      # -----Fuzzy Finder-----
      plenary-nvim
      telescope-nvim
      telescope-fzf-native-nvim
      git-worktree-nvim
      telescope-undo-nvim

      # -----Highlighting-----
      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-context
      rainbow-delimiters-nvim

      # (pkgs.vimUtils.buildVimPlugin {
      #   pname = "dolphin-vim";
      #   version = "2021-11-01";
      #   src = pkgs.fetchFromGitLab {
      #     owner = "jo1gi";
      #     repo = "dolphin-vim";
      #     rev = "1bddf3c798cbb425f0a288c1a3640e06bea2fccc";
      #     hash = "sha256-28fPWSYOHyBLiwVkGyYoslpWnqrBFozaSnhFNQ8NG9o=";
      #   };
      # })

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
      local transparent = true
      require("catppuccin").setup {
        flavour = "${if config.syde.theming.prefer-dark then "mocha" else "latte"}",
        transparent_background = transparent,
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
          treesitter_context = transparent,
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

{ config, pkgs, ... }:

{
  config = {

    programs.neovim = {
      package = pkgs.neovim-nightly;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      viAlias = true;
      plugins = with pkgs.vimPlugins; [
        # -----LSP-----
        nvim-lspconfig
        lspsaga-nvim
        # fidget-nvim
        neodev-nvim # Neovim lua API LSP Helper


        # -----Completion-----
        lspkind-nvim
        nvim-cmp
        cmp-cmdline
        cmp-nvim-lsp-signature-help
        cmp-nvim-lua
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        # codeium-nvim
        cmp-buffer
        luasnip
        friendly-snippets
        copilot-lua

        # -----Workflow-----
        harpoon2
        nvim-autopairs
        gitsigns-nvim
        neogit
        diffview-nvim
        mini-nvim
        vim-be-good
        vim-table-mode
        # obsidian-nvim

        (pkgs.vimUtils.buildVimPlugin {
          pname = "obsidian-nvim";
          version = "1";
          src = pkgs.fetchFromGitHub {
            owner = "epwalsh";
            repo = "obsidian.nvim";
            rev = "169f3ef1d4db49090c032c0a7f09215437449492";
            sha256 = "sha256-sMBFv5ROw/ahlI85OVvdShxvahmAouMUbhuQS84pI1w=";
          };
        })


        undotree

        # -----Fuzzy Finder-----
        plenary-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim
        git-worktree-nvim

        # -----Highlighting-----
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        nvim-treesitter-context
        rainbow-delimiters-nvim

        # -----UI-----
        which-key-nvim
        trouble-nvim
        indent-blankline-nvim
        nvim-web-devicons
        todo-comments-nvim
        nui-nvim
        catppuccin-nvim
      ];
      extraLuaConfig = ''
        vim.loader.enable()
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
        require('syde')
      '';
      extraPackages = with pkgs; [
        nodejs-slim_20 # For github copilot
      ];
    };

    syde.unfreePredicates = [
      "codeium"
    ];
  };
}

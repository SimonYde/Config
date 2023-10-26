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
      unstablePlugins.nvim-lspconfig
      lspkind-nvim
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
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-nvim-lua
      # cmp-nvim-lsp-signature-help
      cmp_luasnip
      luasnip
      copilot-lua

      # -----Workflow-----
      unstablePlugins.harpoon # Stable version is broken for Neovim Nightly
      gitsigns-nvim
      neogit
      diffview-nvim
      unstablePlugins.mini-nvim
      vim-be-good

      # -----Fuzzy Finder-----
      unstablePlugins.telescope-nvim
      unstablePlugins.plenary-nvim
      telescope-fzf-native-nvim
      git-worktree-nvim
      telescope-undo-nvim

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
      # (pkgs.vimUtils.buildVimPlugin {
      #   pname = "lualine-so-fancy-nvim";
      #   version = "1";
      #   src = pkgs.fetchFromGitHub {
      #     owner = "meuter";
      #     repo = "lualine-so-fancy.nvim";
      #     rev = "21284504fed2776668fdea8743a528774de5d2e1";
      #     sha256 = "sha256-JMz3Dv3poGoYQU+iq/jtgyHECZLx+6mLCvqUex/a0SY=";
      #   };
      # })
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
}

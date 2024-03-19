{ config, pkgs, ... }:

let cfg = config.programs.neovim; in
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

        # -----Completion-----
        lspkind-nvim
        nvim-cmp
        cmp-cmdline
        cmp-nvim-lsp-signature-help
        cmp-nvim-lua
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        cmp-buffer
        luasnip
        friendly-snippets
        copilot-lua
        codeium-nvim

        # -----Workflow-----
        harpoon2
        nvim-autopairs
        gitsigns-nvim
        neogit
        diffview-nvim
        mini-nvim
        vim-sleuth
        vim-be-good
        vim-table-mode
        undotree

        vim-just

        # (pkgs.vimUtils.buildVimPlugin {
        #   pname = "just.vim";
        #   version = "1";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "tmccombs";
        #     repo = "just.vim";
        #     rev = "54188993a7c11943f2a763337a017d0e3191bd0c";
        #     sha256 = "sha256-9zVyZa6jHXj86SMAlqlL8C4xGBFdYIr/eEHHdQpFPTw=";
        #   };
        # })


        # obsidian-nvim # NOTE: currently has bugs on unstable
        (pkgs.vimUtils.buildVimPlugin {
          pname = "obsidian-nvim";
          version = "2024-03-01";
          src = pkgs.fetchFromGitHub {
            owner = "epwalsh";
            repo = "obsidian.nvim";
            rev = "169f3ef1d4db49090c032c0a7f09215437449492";
            sha256 = "sha256-sMBFv5ROw/ahlI85OVvdShxvahmAouMUbhuQS84pI1w=";
          };
        })

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
        # catppuccin-nvim
      ] ++
      (if config.colorScheme.slug == "catppuccin-mocha"
        || config.colorScheme.slug == "catppuccin-latte"
      then [ catppuccin-nvim ] else [ ]);
      extraLuaConfig = with config.colorScheme.palette; ''
        vim.loader.enable()
        VARIANT = "${config.colorScheme.variant}"
        PALETTE = {
          base00 = "#${base00}",
          base01 = "#${base01}",
          base02 = "#${base02}",
          base03 = "#${base03}",
          base04 = "#${base04}",
          base05 = "#${base05}",
          base06 = "#${base06}",
          base07 = "#${base07}",
          base08 = "#${base08}",
          base09 = "#${base09}",
          base0A = "#${base0A}",
          base0B = "#${base0B}",
          base0C = "#${base0C}",
          base0D = "#${base0D}",
          base0E = "#${base0E}",
          base0F = "#${base0F}",
        }
        require('syde')
      '';
      extraPackages = with pkgs;
        let packages = [ ]; in
        if
          builtins.elem
            vimPlugins.copilot-lua
            cfg.plugins
        then
          packages ++ [
            pkgs.nodejs-slim_20
          ]
        else packages;
    };

    syde.unfreePredicates = [
      "codeium"
    ];
  };
}

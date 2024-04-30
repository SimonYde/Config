{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  catppuccin = [
    "catppuccin-latte"
    "catppuccin-mocha"
  ];
  neogit-nightly = pkgs.vimUtils.buildVimPlugin {
    version = "1";
    pname = "neogit-nightly";
    src = inputs.neogit-nightly;
  };
  mapLazy = map (pkg: {
    plugin = pkg;
    optional = true;
  }); # Takes a list of plugins and maps them to load lazily
  cfg = config.programs.neovim;
in
{
  config = lib.mkIf cfg.enable {
    programs.neovim = {
      package = pkgs.neovim-nightly;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      plugins =
        with pkgs.vimPlugins;
        [
          # -----LSP-----
          nvim-lspconfig
          lspsaga-nvim

          # -----Completion-----
          lspkind-nvim
          nvim-cmp
          cmp-nvim-lsp-signature-help
          cmp-nvim-lua
          cmp-nvim-lsp
          cmp-cmdline
          cmp-path
          cmp-buffer
          cmp_luasnip
          friendly-snippets
          copilot-lua
          # codeium-nvim

          # -----Workflow-----
          conform-nvim
          harpoon2
          nvim-autopairs
          gitsigns-nvim
          neogit-nightly # NOTE: Supports neovim nightly
          mini-nvim
          vim-sleuth
          # vim-table-mode
          # vim-be-good
          undotree
          nvim-dap
          nvim-dap-ui
          nvim-nio

          obsidian-nvim

          # -----Fuzzy Finder-----
          plenary-nvim
          telescope-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim
          git-worktree-nvim


          # -----UI-----
          which-key-nvim
          nvim-web-devicons
          todo-comments-nvim
          nui-nvim
        ]
        ++ mapLazy [
          luasnip
          trouble-nvim
          indent-blankline-nvim
          diffview-nvim

          # -----Highlighting-----
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          nvim-treesitter-context
          rainbow-delimiters-nvim

        ]
        ++ (if builtins.elem config.colorScheme.slug catppuccin then [ catppuccin-nvim ] else [ ]);

      extraLuaConfig = with config.colorScheme.palette; ''
        vim.loader.enable()
        require('syde.load').setup()
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
      extraPackages =
        with pkgs;
        let
          packages = [ ];
        in
        if builtins.elem vimPlugins.copilot-lua cfg.plugins then
          packages ++ [ pkgs.nodejs-slim_20 ]
        else
          packages;
    };

    syde.unfreePredicates = [ "codeium" ];
  };
}

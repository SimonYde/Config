{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (builtins) head;
  inherit (lib) splitString;

  is_catppuccin = (head (splitString "-" config.colorScheme.slug)) == "catppuccin";
  mapLazy = map (pkg: {
    plugin = pkg;
    optional = true;
  }); # Takes a list of plugins and maps them to load lazily
  cfg = config.programs.neovim;
in
{
  config = lib.mkIf cfg.enable {
    programs.neovim = {
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      plugins =
        with pkgs.vimPlugins;
        [
          # -----LSP-----
          nvim-lspconfig
          lspsaga-nvim
          lsp_signature-nvim

          # -----Completion-----
          lspkind-nvim
          nvim-cmp
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
          project-nvim
          conform-nvim
          harpoon2
          nvim-autopairs
          gitsigns-nvim
          rustaceanvim

          neogit
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
        ++ (if is_catppuccin then [ catppuccin-nvim ] else [ ]);

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

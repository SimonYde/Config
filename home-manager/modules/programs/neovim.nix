{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib) mkIf;
  mapLazy = map (pkg: {
    plugin = pkg;
    optional = true;
  }); # Takes a list of plugins and maps them to load lazily
  cfg = config.programs.neovim;
in
{
  config = mkIf cfg.enable {
    programs.neovim = {
      package = pkgs.neovim;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      viAlias = true;
      withRuby = false;
      withNodeJs = false;
      withPython3 = false;
      plugins =
        with pkgs.vimPlugins;
        [
          # -----LSP-----
          nvim-lspconfig
          lsp_signature-nvim
          otter-nvim

          # -----Completion-----
          nvim-cmp
          cmp-git
          cmp-nvim-lsp
          # cmp-cmdline
          cmp-path
          cmp-buffer
          cmp_luasnip
          friendly-snippets

          # -----Config writing-----
          lazydev-nvim

          # -----Workflow-----
          conform-nvim
          nvim-autopairs
          rustaceanvim

          mini-nvim
          vim-sleuth
          undotree
          nvim-dap
          nvim-dap-ui

          obsidian-nvim
          image-nvim

          # -----Fuzzy Finder-----
          telescope-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim

          # -----UI-----
          which-key-nvim
          nvim-treesitter
        ]
        ++ mapLazy [
          # ----- Workflow -----
          luvit-meta
          luasnip
          trouble-nvim
          diffview-nvim
          neogit
          todo-comments-nvim
          img-clip-nvim

          # ----- UI -----
          lspsaga-nvim
          indent-blankline-nvim
          render-markdown-nvim
          nvim-treesitter-textobjects
          nvim-treesitter-context
          rainbow-delimiters-nvim
        ];
      extraLuaConfig =
        with config.syde.theming.palette-hex; # lua
        ''
          vim.loader.enable()
          _G.VARIANT = "${config.colorScheme.variant}"
          _G.PALETTE = {
            base00 = "${base00}", base01 = "${base01}", base02 = "${base02}", base03 = "${base03}",
            base04 = "${base04}", base05 = "${base05}", base06 = "${base06}", base07 = "${base07}",
            base08 = "${base08}", base09 = "${base09}", base0A = "${base0A}", base0B = "${base0B}",
            base0C = "${base0C}", base0D = "${base0D}", base0E = "${base0E}", base0F = "${base0F}",
          }
          vim.g.transparent = ${if config.syde.terminal.opacity != 1.0 then "true" else "false"}
          _G.Config = { }
          require('syde')
        '';
    };
  };
}

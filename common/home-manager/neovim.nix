{
  lib,
  config,
  pkgs,
  ...
}:

{
  programs.neovim = lib.mkMerge [
    {
      package = pkgs.neovim;
      defaultEditor = true;

      vimAlias = true;
      viAlias = true;

      withRuby = false;
      withNodeJs = false;
      withPython3 = false;

      plugins =
        let
          mapLazy = map (plugin: {
            inherit plugin;
            optional = true;
          });
        in
        with pkgs.vimPlugins;
        [
          # -----LSP-----
          nvim-lspconfig

          # -----Workflow-----
          nvim-autopairs
          mini-nvim
          snacks-nvim
          vim-sleuth
          undotree
          friendly-snippets

          obsidian-nvim

          # -----UI-----
          which-key-nvim
          nvim-treesitter
          tip-vim
        ]
        ++ mapLazy [
          # ----- Completion -----
          blink-cmp
          blink-compat

          # ----- Workflow -----
          conform-nvim
          trouble-nvim
          diffview-nvim
          neogit
          todo-comments-nvim
          img-clip-nvim
          nvim-ufo

          nvim-dap
          nvim-dap-ui

          (lib.mkIf config.programs.yazi.enable yazi-nvim)

          # ----- UI -----
          lspsaga-nvim
          render-markdown-nvim
          nvim-treesitter-textobjects
          nvim-treesitter-context
          rainbow-delimiters-nvim
        ];

      # Always enable the luac loader first.
      extraLuaConfig = lib.mkOrder 0 "vim.loader.enable()";
    }
    {
      # Always place `require('syde')` at the end.
      extraLuaConfig = lib.mkOrder 1000 "require('syde')";
    }
  ];
}

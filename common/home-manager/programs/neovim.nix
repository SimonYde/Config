{ pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    ghostscript # for snacks.nvim pdf rendering
  ];

  programs.neovim = lib.mkMerge [
    {
      package = pkgs.neovim;
      defaultEditor = true;

      vimAlias = true;
      vimdiffAlias = true;
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
          luvit-meta
          trouble-nvim
          diffview-nvim
          neogit
          todo-comments-nvim
          img-clip-nvim

          nvim-ufo
          nvim-dap
          nvim-dap-ui

          # ----- UI -----
          lspsaga-nvim
          render-markdown-nvim
          nvim-treesitter-textobjects
          nvim-treesitter-context
          rainbow-delimiters-nvim
        ];

      # Always enable the luac loader first.
      extraLuaConfig = lib.mkOrder 10 ''
        vim.loader.enable()
      '';
    }
    {
      # Always place `require('syde')` at the end.
      extraLuaConfig = lib.mkOrder 1000 ''
        require('syde')
      '';
    }
  ];
}

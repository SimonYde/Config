{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.neovim;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tree-sitter
      gcc
    ];
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
          # ----- Workflow -----
          nvim-autopairs
          mini-nvim
          snacks-nvim
          vim-sleuth
          undotree
          friendly-snippets
          catppuccin-nvim
          lazydev-nvim

          # ----- UI -----
          vim-alloy
        ]
        ++ config.lib.meta.lazyNeovimPlugins [
          # ----- Completion -----
          blink-cmp
          wezterm-types
          nvim-lspconfig

          # ----- Workflow -----
          conform-nvim
          trouble-nvim
          diffview-nvim
          neogit
          todo-comments-nvim
          img-clip-nvim

          yazi-nvim

          # ----- UI -----
          lspsaga-nvim
          nvim-ufo
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          render-markdown-nvim
          which-key-nvim
        ];

      extraPackages = with pkgs; [
        inotify-tools
        tree-sitter
        ghostscript # snacks.nvim PDF rendering
      ];
    };
  };
}

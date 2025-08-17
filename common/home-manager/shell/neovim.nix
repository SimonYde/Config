{ config, pkgs, ... }:

{
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
        nvim-treesitter
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
        indent-blankline-nvim
        lspsaga-nvim
        nvim-treesitter-context
        nvim-treesitter-textobjects
        rainbow-delimiters-nvim
        render-markdown-nvim
        which-key-nvim
      ];

    extraPackages = with pkgs; [
      ghostscript # snacks.nvim PDF rendering
    ];
  };
}

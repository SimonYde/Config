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
        obsidian-nvim

        # ----- UI -----
        which-key-nvim
        nvim-treesitter
        tip-vim
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

        nvim-dap
        nvim-dap-ui

        yazi-nvim

        # ----- UI -----
        lspsaga-nvim
        render-markdown-nvim
        nvim-treesitter-textobjects
        nvim-treesitter-context
        rainbow-delimiters-nvim
      ];

    extraPackages = with pkgs; [
      ghostscript # snacks.nvim PDF rendering
    ];
  };
}

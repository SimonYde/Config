{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    ghostscript # for snacks.nvim pdf rendering
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
    extraLuaConfig =
      # if (config.lib ? stylix) then
      with config.lib.stylix.colors.withHashtag; # lua
      ''
        vim.loader.enable()
        _G.PALETTE = {
          base00 = "${base00}", base01 = "${base01}", base02 = "${base02}", base03 = "${base03}",
          base04 = "${base04}", base05 = "${base05}", base06 = "${base06}", base07 = "${base07}",
          base08 = "${base08}", base09 = "${base09}", base0A = "${base0A}", base0B = "${base0B}",
          base0C = "${base0C}", base0D = "${base0D}", base0E = "${base0E}", base0F = "${base0F}",
        }
        _G.Config = { }
        require('syde')
      ''; # lua
    # else
    #   ''
    #     vim.loader.enable()
    #     _G.Config = { }
    #     require('syde')
    #   '';
  };
}

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
          lspsaga-nvim
          lsp_signature-nvim
          otter-nvim

          # -----Completion-----
          nvim-cmp
          cmp-git
          cmp-nvim-lsp
          cmp-cmdline
          cmp-path
          cmp-buffer
          cmp_luasnip
          friendly-snippets

          # -----Workflow-----
          conform-nvim
          nvim-autopairs
          rustaceanvim

          neogit
          mini-nvim
          vim-sleuth
          undotree
          nvim-dap
          nvim-dap-ui

          obsidian-nvim

          # -----Fuzzy Finder-----
          telescope-nvim
          telescope-fzf-native-nvim
          telescope-ui-select-nvim

          # -----UI-----
          which-key-nvim
          todo-comments-nvim
          # nvim-treesitter.withAllGrammars
          (nvim-treesitter.withPlugins (p: [
            p.bash
            p.hyprlang
            p.kdl

            p.vim
            p.vimdoc
            p.query
            p.markdown
            p.markdown-inline

            p.csv
            p.ini
            p.json
            p.jsonc
            p.jq
            p.yaml
            p.toml

            p.git_config
            p.git_rebase
            p.gitattributes
            p.gitcommit
            p.gitignore

            p.just
            p.make

            p.html
            p.css
            p.scss
            p.javascript
          ]))
        ]
        ++ mapLazy [
          luasnip
          trouble-nvim
          indent-blankline-nvim
          diffview-nvim

          # -----Highlighting-----
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
            base00 = "${base00}",
            base01 = "${base01}",
            base02 = "${base02}",
            base03 = "${base03}",
            base04 = "${base04}",
            base05 = "${base05}",
            base06 = "${base06}",
            base07 = "${base07}",
            base08 = "${base08}",
            base09 = "${base09}",
            base0A = "${base0A}",
            base0B = "${base0B}",
            base0C = "${base0C}",
            base0D = "${base0D}",
            base0E = "${base0E}",
            base0F = "${base0F}",
          }
          vim.g.transparent = ${if config.syde.terminal.opacity != 1.0 then "true" else "false"}
          _G.Config = {
            path_source = '${config.xdg.configHome}/nvim/src/'
          }
          dofile(Config.path_source .. 'init.lua')
        '';
      extraPackages = with pkgs; [
        (mkIf (builtins.elem vimPlugins.copilot-lua cfg.plugins) nodejs-slim_20)
      ];
    };
  };
}

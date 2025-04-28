inputs: [
  inputs.neovim-nightly.overlays.default

  (final: prev: {
    stable = import inputs.stable { inherit (prev) system config; };
    nushell-wrapped = final.writeTextFile {
      name = "nushell-wrapped";

      executable = true;
      destination = "/bin/nu";
      passthru.shellPath = "/bin/nu";

      text = # bash
        ''
          #!/usr/bin/env -S bash --login
          exec ${final.nushell}/bin/nu "$@"
        '';
    };

    grawlix = inputs.grawlix.packages.${prev.system}.default;
    agenix = inputs.agenix.packages.${prev.system}.default.override {
      ageBin = prev.lib.getExe final.rage;
    };
    pix2tex = inputs.pix2tex.packages.${prev.system}.default;
    audiobook-dl = inputs.audiobook-dl.packages.${prev.system}.default;
    zen-browser = inputs.zen-browser.packages.${prev.system}.default;
    etilbudsavis-cli = inputs.etilbudsavis-cli.packages.${prev.system}.default;

    inherit (inputs.kattis-cli.packages.${prev.system}) kattis-test kattis-cli;

    vimPlugins = prev.vimPlugins.extend (
      _: _: {
        mini-nvim = prev.vimUtils.buildVimPlugin {
          version = "nightly";
          pname = "mini.nvim";
          src = inputs.mini-nvim;
        };

        nvim-lspconfig = prev.vimUtils.buildVimPlugin {
          version = "nightly";
          pname = "nvim-lspconfig";
          src = inputs.nvim-lspconfig;
        };

        rainbow-delimiters-nvim = prev.vimPlugins.rainbow-delimiters-nvim.overrideAttrs {
          src = inputs.rainbow-delimiters-nvim;
          nvimSkipModule = [
            "rainbow-delimiters._test.highlight"
            "rainbow-delimiters.types"
          ];
        };

        obsidian-nvim = prev.vimPlugins.obsidian-nvim.overrideAttrs {
          checkInputs = [ ];
          nvimSkipModule = [
            "obsidian.pickers._snacks"
            "obsidian.pickers._mini"
            "obsidian.pickers._telescope"
            "obsidian.pickers._fzf"
            "minimal"
          ];
        };

        tip-vim = prev.vimUtils.buildVimPlugin {
          version = "nightly";
          pname = "tip.vim";
          src = inputs.tip-vim;
        };
      }
    );
  })
]

inputs: [
  inputs.neovim-nightly.overlays.default

  (final: prev: {
    stable = import inputs.stable { inherit (prev) system config; };

    nushell-wrapped =
      (final.writeTextFile {
        name = "nushell-wrapped";

        executable = true;
        destination = "/bin/nu";

        text = # bash
          ''
            #!/usr/bin/env -S bash --login
            exec ${final.nushell}/bin/nu "$@"
          '';
      })
      // {
        shellPath = "/bin/nu";
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

    inherit (final.stable) tectonic;

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

        obsidian-nvim = prev.vimPlugins.obsidian-nvim.overrideAttrs {
          checkInputs = [ ];
          src = inputs.obsidian-nvim;
          nvimSkipModule = [
            "obsidian.pickers._mini"
            "obsidian.pickers._fzf"
            "obsidian.pickers._telescope"
            "obsidian.pickers._snacks"
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

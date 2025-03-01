{ inputs, ... }:

{
  config.nixpkgs.overlays = [
    inputs.nur.overlays.default
    inputs.neovim-nightly.overlays.default
    # inputs.hyprland.overlays.default

    (final: prev: {
      stable = import inputs.stable {
        inherit (prev) system config;
      };
      nushell-wrapped =
        (final.writeTextFile {
          name = "nushell-wrapped";

          executable = true;
          destination = "/bin/nu";

          text = ''
            #!/usr/bin/env -S bash --login
            exec ${final.nushell}/bin/nu "$@"
          '';
        })
        // {
          shellPath = "/bin/nu";
        };
      grawlix = inputs.grawlix.packages.${prev.system}.default;
      pix2tex = inputs.pix2tex.packages.${prev.system}.default;
      audiobook-dl = inputs.audiobook-dl.packages.${prev.system}.default;

      inherit (inputs.kattis-cli.packages.${prev.system}) kattis-test kattis-cli;

      python3 = prev.python3.override {
        packageOverrides = _: _: {
          randcrack = inputs.randcrack.packages.${prev.system}.default;
        };
      };

      vimPlugins = prev.vimPlugins // {
        tip-vim = prev.vimUtils.buildVimPlugin {
          version = "nightly";
          pname = "tip.vim";
          src = inputs.tip-vim;
        };
        obsidian-nvim = prev.vimPlugins.obsidian-nvim.overrideAttrs {
          checkInputs = [ ];
          nvimSkipModule = [
            "obsidian.pickers._mini"
            "obsidian.pickers._fzf"
            "obsidian.pickers._telescope"
          ];
        };
        snacks-nvim =
          (prev.vimUtils.buildVimPlugin {
            version = "nightly";
            pname = "snacks.nvim";
            src = inputs.snacks-nvim;
          }).overrideAttrs
            {
              nvimSkipModule = [
                # Requires setup call first
                "snacks.dashboard"
                "snacks.debug"
                "snacks.dim"
                "snacks.git"
                "snacks.image.image"
                "snacks.image.init"
                "snacks.image.placement"
                "snacks.image.convert"
                "snacks.indent"
                "snacks.input"
                "snacks.lazygit"
                "snacks.notifier"
                "snacks.picker.actions"
                "snacks.picker.config.highlights"
                "snacks.picker.core.list"
                "snacks.scratch"
                "snacks.scroll"
                "snacks.terminal"
                "snacks.win"
                "snacks.words"
                "snacks.zen"
                # Optional trouble integration
                "trouble.sources.profiler"
                # TODO: Plugin requires libsqlite available, create a test for it
                "snacks.picker.util.db"
              ];
            };
        mini-nvim = prev.vimUtils.buildVimPlugin {
          version = "nightly";
          pname = "mini.nvim";
          src = inputs.mini-nvim;
        };
      };
    })
  ];
}

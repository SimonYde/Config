inputs: [
  inputs.neovim-nightly.overlays.default
  inputs.nvim-treesitter-main.overlays.default
  inputs.nur.overlays.default

  (
    final: prev:
    let
      mkDate =
        { lastModifiedDate, ... }:
        (final.lib.concatStringsSep "-" [
          (builtins.substring 0 4 lastModifiedDate)
          (builtins.substring 4 2 lastModifiedDate)
          (builtins.substring 6 2 lastModifiedDate)
        ]);

      inherit (prev) config;
      inherit (prev.stdenv.hostPlatform) system;
    in
    {
      stable = import inputs.stable { inherit system config; };

      inherit (final.stable) libreoffice rclone-browser lutris;

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

      inherit (inputs.rustaceanvim.packages.${system}) codelldb;
      inherit (inputs.typst-languagetool.packages.${system}) typst-languagetool-lsp;
      inherit (inputs.walker.packages.${system}) walker;

      grawlix = inputs.grawlix.packages.${system}.default;
      agenix = inputs.agenix.packages.${system}.default.override {
        ageBin = prev.lib.getExe final.rage;
      };
      audiobook-dl = inputs.audiobook-dl.packages.${system}.default;
      etilbudsavis-cli = inputs.etilbudsavis-cli.packages.${system}.default;

      jellyfin-web = prev.jellyfin-web.overrideAttrs (
        finalAttrs: previousAttrs: {
          installPhase = ''
            runHook preInstall

            # this is the important line
            sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

            mkdir -p $out/share
            cp -a dist $out/share/jellyfin-web

            runHook postInstall
          '';
        }
      );

      inherit (inputs.kattis-cli.packages.${system}) kattis-test kattis-cli;

      vimPlugins = prev.vimPlugins.extend (
        _: _: {
          inherit (inputs.rustaceanvim.packages.${system}) rustaceanvim;

          mini-nvim = prev.vimUtils.buildVimPlugin {
            version = mkDate inputs.mini-nvim;
            pname = "mini.nvim";
            src = inputs.mini-nvim;
          };

          nvim-lspconfig = prev.vimUtils.buildVimPlugin {
            version = mkDate inputs.nvim-lspconfig;
            pname = "nvim-lspconfig";
            src = inputs.nvim-lspconfig;
          };

          trouble-nvim = prev.vimPlugins.trouble-nvim.overrideAttrs {
            src = inputs.trouble-nvim;
            version = mkDate inputs.trouble-nvim;
            nvimSkipModule = [
              "trouble.docs"
            ];
          };

          vim-alloy = prev.vimUtils.buildVimPlugin {
            version = mkDate inputs.vim-alloy;
            pname = "vim-alloy";
            src = inputs.vim-alloy;
          };

          wezterm-types =
            (prev.vimUtils.buildVimPlugin {
              version = mkDate inputs.wezterm-types;
              pname = "wezterm-types";
              src = inputs.wezterm-types;
            }).overrideAttrs
              {
                nvimSkipModule = [
                  "wezterm"
                ];

              };
        }
      );
    }
  )
]

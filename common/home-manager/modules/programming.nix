{
  lib,
  pkgs,
  config,
  ...
}:

let
  inherit (lib)
    mkPackageOption
    mkEnableOption
    mkMerge
    mkIf
    ;
  cfg = config.syde.programming;
in
{
  config = mkMerge [
    (mkIf cfg.enable {
      programs = {
        # Terminal Editors
        helix.enable = false;
        neovim.enable = true;
      };

      syde.programming = {
        bash.enable = true;
        cpp.enable = false;
        gleam.enable = false;
        go.enable = false;
        java.enable = false;
        latex.enable = true;
        lua.enable = true;
        nix.enable = true;
        ocaml.enable = false;
        odin.enable = true;
        python.enable = true;
        rust.enable = true;
        scala.enable = false;
        typst.enable = true;
        zig.enable = true;
      };

      home.packages = with pkgs; [
        kattis-cli
        kattis-test
      ];
    })

    (mkIf cfg.bash.enable {
      home.packages = with pkgs; [ bash-language-server ];
    })

    (mkIf cfg.cpp.enable {
      home.packages = with pkgs; [
        libgcc
        clang-tools
      ];
    })

    (mkIf cfg.gleam.enable {
      home.packages = with pkgs; [
        gleam
        beam.interpreters.erlang
        beam.packages.erlang.rebar3
      ];
    })

    (mkIf cfg.go.enable {
      home.packages = with pkgs; [
        go # CLI
        delve # Debugger
        gopls # LSP
      ];

      programs.neovim.plugins = with pkgs.vimPlugins; [
        nvim-dap-go # debugging support
      ];

      home.sessionVariables.GOPATH = "${config.xdg.dataHome}/go";
    })

    (mkIf cfg.java.enable {
      home.packages = with pkgs; [
        gradle
        gradle-completion
        jdt-language-server
        maven
        cfg.java.jdk
      ];

      home.sessionVariables.JAVA_HOME = cfg.java.jdk;

      programs.neovim.plugins = with pkgs.vimPlugins; [
        nvim-jdtls
      ];
    })

    (mkIf cfg.latex.enable {
      home.packages = with pkgs; [
        texlab
        tectonic
        harper
      ];
    })

    (mkIf cfg.lua.enable {
      home.packages = with pkgs; [
        stylua
        lua-language-server
      ];

      programs.neovim.plugins = with pkgs.vimPlugins; [
        lazydev-nvim
        {
          plugin = luvit-meta;
          optional = true;
        }
      ];
    })

    (mkIf cfg.nix.enable {
      home.packages = with pkgs; [
        nil
        nixd

        nix-init
        nixfmt-rfc-style
        nix-output-monitor
      ];
    })

    (mkIf cfg.ocaml.enable {
      home.packages = with pkgs; [
        ocamlPackages.ocamlformat
        ocamlPackages.ocaml-lsp
        ocaml
      ];

      programs.opam.enable = true;
    })

    (mkIf cfg.odin.enable {
      home.packages = with pkgs; [
        odin
        ols
      ];
    })

    (mkIf cfg.python.enable {
      home.packages = with pkgs; [
        basedpyright

        (python3.withPackages (
          ps: with ps; [
            python-lsp-server
            python-lsp-ruff
            pylsp-mypy
            types-requests

            numpy
            pandas
            sympy
            scipy
            matplotlib
            debugpy
            pycryptodome

            # CTF
            randcrack
            pwntools
          ]
        ))
      ];

      programs.ruff = {
        enable = true;
        settings = {
          line-length = 100;
        };
      };

      programs.neovim.plugins = with pkgs.vimPlugins; [
        nvim-dap-python
      ];
    })

    (mkIf cfg.scala.enable {
      home.packages = with pkgs; [
        scala
        scalafmt
        metals
      ];

      programs.sbt.enable = true;
    })

    (mkIf cfg.rust.enable {
      home.packages = with pkgs; [
        cargo
        rustc
        lldb
        rust-analyzer
        rustfmt
        clippy
        gcc
      ];

      programs.neovim.plugins = with pkgs.vimPlugins; [
        rustaceanvim # Extra rust support
        crates-nvim
      ];

      home.sessionVariables.CARGO_HOME = "${config.xdg.cacheHome}/cargo";
    })

    (mkIf cfg.typst.enable {
      home.packages = with pkgs; [
        typst # Compiler
        harper # Spellchecking
        tinymist # LSP
        typstyle # Formatter
        polylux2pdfpc # Converting slides into `.pdfpc` file with speaker notes
      ];
    })

    (mkIf cfg.zig.enable {
      home.packages = with pkgs; [
        zig
        zls
      ];
    })
  ];

  options.syde.programming = {
    enable = mkEnableOption "Development tools";

    bash.enable = mkEnableOption "Bash tools";

    cpp.enable = mkEnableOption "C++ tools";

    gleam.enable = mkEnableOption "Gleam tools";

    go.enable = mkEnableOption "Golang tools";

    java.enable = mkEnableOption "Java tools";
    java.jdk = mkPackageOption pkgs "jdk" { };

    latex.enable = mkEnableOption "LaTeX tools";

    lua.enable = mkEnableOption "Lua tools";

    nix.enable = mkEnableOption "Nix tools";

    ocaml.enable = mkEnableOption "OCaml tools";

    odin.enable = mkEnableOption "Odin tools";

    python.enable = mkEnableOption "Python tools";

    scala.enable = mkEnableOption "Scala tools";

    rust.enable = mkEnableOption "Rust tools";

    typst.enable = mkEnableOption "Typst tools";

    zig.enable = mkEnableOption "Zig tools";
  };
}

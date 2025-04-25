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
  cfg = config.syde.development;
in
{
  imports = [ ./topiary.nix ];

  config = mkMerge [
    {
      syde.development = {
        bash.enable = true;

        cpp.enable = false;

        clojure.enable = false;

        gleam.enable = false;

        go.enable = false;

        java.enable = true;

        latex.enable = true;

        lua.enable = true;

        nix.enable = true;

        ocaml.enable = false;

        odin.enable = true;

        python.enable = true;

        rust.enable = true;

        scala = {
          enable = true;
          package = pkgs.scala_2_12;
        };

        typst.enable = true;

        zig.enable = true;
      };

      home.packages = with pkgs; [
        gnumake
        just

        devcontainer

        dua
        lls
        ouch # archive tool

        libqalculate # Math tool

        ast-grep

        gitoxide # Rust git implementation.
        git-revise
        git-absorb
        git-gr
        git-crypt
        glab

        kattis-cli
        kattis-test

        tokei
        tlrc
      ];

      programs = {
        bat.extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
        ];

        direnv = {
          enable = true;
          enableNushellIntegration = false;
          nix-direnv.enable = true;

          config.global = {
            warn_timeout = "1m";
            log_format = "-";
            log_filter = "^$";
          };
        };

        gh = {
          enable = true;
          settings.git_protocol = "ssh";
        };

        git.difftastic = {
          enable = true;
          display = "inline";
        };

        gpg = {
          enable = true;
          homedir = "${config.xdg.configHome}/gpg";
        };

        jujutsu = {
          enable = true;

          settings = {
            user = {
              name = "Simon Yde";
              email = "git@simonyde.com";
            };
          };
        };

        lazygit.enable = true;

        man.enable = true;

        topiary.enable = true;
      };

      services = {
        gpg-agent = {
          enable = true;
          enableSshSupport = true;
          enableNushellIntegration = true;
          pinentryPackage = pkgs.pinentry-tty;
          extraConfig = ''
            allow-loopback-pinentry
          '';
        };

        tldr-update = {
          enable = true;
          package = pkgs.tlrc;
        };
      };

    }

    (mkIf cfg.bash.enable {
      home.packages = with pkgs; [
        bash-language-server
      ];
    })

    (mkIf cfg.cpp.enable {
      home.packages = with pkgs; [
        libgcc
        clang-tools
      ];
    })

    (mkIf cfg.clojure.enable {
      home.packages = with pkgs; [
        clojure
        cljfmt
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
      home = {
        packages = with pkgs; [
          go # CLI
          delve # Debugger
          gopls # LSP
        ];

        sessionVariables.GOPATH = "${config.xdg.dataHome}/go";
      };

      programs.neovim.plugins = with pkgs.vimPlugins; [
        nvim-dap-go # debugging support
      ];
    })

    (mkIf cfg.java.enable {
      home = {
        packages = with pkgs; [
          jdt-language-server
          maven

          cfg.java.jdk
        ];

        sessionVariables.JAVA_HOME = cfg.java.jdk;
      };

      programs = {
        gradle = {
          enable = true;
          home = ".config/gradle";

          settings = {
            "org.gradle.caching" = true;
            "org.gradle.parallel" = true;
            "org.gradle.jvmargs" = "-XX:MaxMetaspaceSize=384m";
            "org.gradle.home" = cfg.java.jdk;
          };
        };

        neovim.plugins = with pkgs.vimPlugins; [ nvim-jdtls ];
      };
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

      programs.neovim.plugins = with pkgs.vimPlugins; [ lazydev-nvim ];
    })

    (mkIf cfg.nix.enable {
      home.packages = with pkgs; [
        nil
        nixd

        hydra-check
        nix-diff
        nix-init
        nix-output-monitor
        nix-tree
        nix-update
        nixfmt-rfc-style
        nixpkgs-review
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
      home.packages = [
        pkgs.basedpyright

        (pkgs.python3.withPackages (
          pythonPkgs: with pythonPkgs; [
            types-requests

            numpy
            pandas
            sympy
            scipy
            matplotlib
            debugpy
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
        cfg.scala.package

        scalafmt
        metals
      ];

      programs.sbt = {
        enable = true;
        baseUserConfigPath = ".config/sbt";
      };
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

  options.syde.development = {
    bash.enable = mkEnableOption "Bash tools";

    cpp.enable = mkEnableOption "C++ tools";

    clojure.enable = mkEnableOption "Clojure tools";

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
    scala.package = mkPackageOption pkgs "scala" { };

    rust.enable = mkEnableOption "Rust tools";

    typst.enable = mkEnableOption "Typst tools";

    zig.enable = mkEnableOption "Zig tools";
  };
}

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
        cpp.enable = true;
        clojure.enable = false;
        gleam.enable = false;
        go.enable = false;
        java.enable = false;
        latex.enable = false;
        lua.enable = true;
        nix.enable = true;
        ocaml.enable = false;
        odin.enable = false;
        python.enable = true;
        rust.enable = true;
        scala.enable = false;
        typst.enable = true;
        zig.enable = false;
      };

      home.packages = with pkgs; [
        gnumake
        just

        # devcontainer # use development docker images

        dua
        lls
        ouch # archive tool

        libqalculate # Math tool

        ast-grep

        glab

        kattis-cli
        kattis-test

        tokei
        tlrc
      ];

      programs = {
        bat = {
          config = {
            style = "numbers,changes";
            pager = "less -FR";
          };
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batman
            batwatch
          ];
        };

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

        delta = {
          enable = true;
          enableGitIntegration = true;
          options = {
            hyperlinks = true;
            true-color = "always";
            features = "decorations";
            whitespace-error-style = "22 reverse";
          };
        };

        jq.enable = true;

        jjui = {
          enable = true;
        };

        jujutsu = {
          enable = true;

          settings = {
            user = {
              name = "Simon Yde";
              email = "git@simonyde.com";
            };

            ui = {
              default-command = "status";
              pager = lib.getExe pkgs.delta;
              diff-formatter = ":git";
              diff-editor = ":builtin";
              merge-editor = "${lib.getExe pkgs.mergiraf}";
            };

            signing = {
              behavior = "own";
              backend = "ssh";
              key = (import ../../keys.nix).syde;
            };

            aliases = {
              c = [ "commit" ];
              ci = [
                "commit"
                "--interactive"
              ];
              e = [ "edit" ];
              i = [
                "git"
                "init"
                "--colocate"
              ];

              log-recent = [
                "log"
                "-r"
                "recent()"
              ];

              nb = [
                "bookmark"
                "create"
                "-r @-"
              ]; # "new bookmark"
              pull = [
                "git"
                "fetch"
              ];
              push = [
                "git"
                "push"
                "--allow-new"
              ];
              r = [ "rebase" ];
              s = [ "squash" ];
              si = [
                "squash"
                "--interactive"
              ];
              tug = [
                "bookmark"
                "move"
                "--from"
                "closest_bookmark(@-)"
                "--to"
                "@-"
              ];
            };

            revset-aliases = {
              "closest_bookmark(to)" = "heads(::to & bookmarks())";
              "recent()" =
                ''(present(@) | ancestors(immutable_heads().., 2) | present(trunk())) & committer_date(after:"3 months ago")'';
            };
          };
        };

        lazygit.enable = true;

        man.enable = true;
        mergiraf.enable = true;

        neovim.plugins =
          with pkgs.vimPlugins;
          [
            tip-vim
          ]
          ++ config.lib.meta.lazyNeovimPlugins [
            obsidian-nvim
            nvim-dap
            nvim-dap-ui
          ];

        topiary.enable = true;

        rbw = {
          enable = true;
          settings = {
            email = "bitwarden@simonyde.com";
            base_url = "https://password.tmcs.dk/";
            lock_timeout = 60 * 60 * 24;
            pinentry = pkgs.pinentry-tty;
          };
        };

        ssh = {
          enable = true;
          enableDefaultConfig = false;

          matchBlocks = {
            "icarus" = {
              hostname = "icarus";
              user = "root";
              forwardAgent = true;
            };

            "perdix" = {
              hostname = "perdix";
              user = "root";
              forwardAgent = true;
            };

            "hestia" = {
              hostname = "hestia";
              user = "root";
              forwardAgent = true;
            };

            "talos" = {
              hostname = "talos";
              user = "root";
              forwardAgent = true;
            };
          };
        };

        nushell.environmentVariables = rec {
          # always use rootless podman
          CONTAINER_HOST = "unix:///run/user/1000/podman/podman.sock";
          DOCKER_HOST = CONTAINER_HOST;
        };
      };

      services = {
        tldr-update = {
          enable = true;
          package = pkgs.tlrc;
        };
      };

      systemd.user.services = {
        rbw-agent = {
          Unit.Description = "rbw agent";

          Service = {
            Type = "simple";
            RuntimeDirectory = "rbw";
            ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/rbw/";
            ExecStart = "${pkgs.rbw}/bin/rbw-agent --no-daemonize";
          };

          Install.WantedBy = [ "default.target" ];
        };

        adb-server = {
          Unit.Description = "adb server daemon";

          Service = {
            Type = "simple";
            ExecStart = "${pkgs.android-tools}/bin/adb -a nodaemon server start";
          };

          Install.WantedBy = [ "default.target" ];
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
        gdb
        clang-tools
      ];

      programs.gcc.enable = true;
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
          delve # Debugger
          gopls # LSP
        ];
      };

      programs.go = {
        enable = true;
        env.GOPATH = "${config.xdg.dataHome}/go";
        telemetry = {
          mode = "off";
        };
      };

      programs.neovim.plugins =
        with pkgs.vimPlugins;
        config.lib.meta.lazyNeovimPlugins [
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

        neovim.plugins = with pkgs.vimPlugins; config.lib.meta.lazyNeovimPlugins [ nvim-jdtls ];
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
        nixfmt
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

      programs.neovim.plugins =
        with pkgs.vimPlugins;
        config.lib.meta.lazyNeovimPlugins [
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
        rustup
        cargo-binstall
        cargo-bloat

        codelldb # from rustaceanvim flake, see `../../overlays.nix`
        pkg-config
      ];

      programs.bacon.enable = true;
      programs.gcc.enable = true;

      programs.neovim.plugins =
        with pkgs.vimPlugins;
        [
          rustaceanvim # Extra rust support
        ]
        ++ config.lib.meta.lazyNeovimPlugins [
          crates-nvim
        ];

      home.sessionPath = [
        "${config.xdg.dataHome}/cargo/bin"
      ];

      home.sessionVariables = {
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      };
    })

    (mkIf cfg.typst.enable {
      home.packages = with pkgs; [
        typst # Compiler
        harper # Spellchecking
        typst-languagetool-lsp # Spellchecking
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

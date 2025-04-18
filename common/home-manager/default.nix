{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  inherit (lib)
    getExe
    mkDefault
    mkIf
    mkMerge
    removePrefix
    ;
in
{
  imports = [
    inputs.agenix.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index
  ];

  config = mkMerge [
    {
      xdg.enable = true;

      age.package = pkgs.rage;

      manual.manpages.enable = false;

      lib.meta = {
        writeNushellScriptBin =
          name: text:
          pkgs.writeTextFile {
            name = "nuscript-${name}";
            text = ''
              #!${getExe pkgs.nushell} --no-config-file
              ${text}
            '';
            destination = "/bin/${name}";
            executable = true;
          };
        configPath = "/home/syde/Config"; # Should be the location of the config repo.
        mkMutableSymlink =
          path:
          config.lib.file.mkOutOfStoreSymlink (
            config.lib.meta.configPath + removePrefix (toString inputs.self) (toString path)
          );
        lazyNeovimPlugins = map (plugin: {
          inherit plugin;
          optional = true;
        });
      };

      home = {
        stateVersion = "24.11";
        preferXdgDirectories = true;

        packages = with pkgs; [
          dogdns # rust version of `dig`
          du-dust # Histogram of file sizes
          erdtree # Tree file view

          lurk # strace alternative
          trippy # network diagnostics
          rsync

          isd # Interactive systemd utility

          nix-your-shell
        ];

        shellAliases = {
          ll = "ls -l";
          lla = "ls -la";
          la = "ls -a";
        };

        # FIXME: hack to reload dbus activated things
        activation.reloadDbus = lib.hm.dag.entryAfter [ "reloadSystemd" ] ''
          if [[ -v DBUS_SESSION_BUS_ADDRESS ]]; then
            run ${pkgs.systemd}/bin/busctl --user call org.freedesktop.DBus /org/freedesktop/DBus org.freedesktop.DBus ReloadConfig
          fi
        '';
      };

      programs = {
        # Shells
        bash.enable = true;
        fish.enable = true;
        nushell.enable = true;

        # Editor
        neovim.enable = true;

        # CLI tools
        atuin.enable = true;
        bat.enable = true;
        btop.enable = true;
        carapace.enable = true;
        fastfetch.enable = true;
        fd.enable = true;
        fzf.enable = true;
        git.enable = true;
        nix-index.enable = true;
        man.enable = mkDefault false;
        pandoc.enable = true;
        ripgrep.enable = true;
        starship.enable = true;
        yazi.enable = true;
        zellij.enable = true;
        zoxide.enable = true;
      };
    }

    {
      programs = {
        atuin.settings = {
          auto_sync = false;
          history_filter = [
            "fg *"
            "pkill *"
            "kill *"
            "rm *"
            "rmdir *"
            "mkdir *"
            "touch *"
          ];
          style = "compact";
          enter_accept = true;
          filter_mode_shell_up_key_binding = "session";
        };

        carapace = {
          enableBashIntegration = true;
          enableNushellIntegration = true;
        };

        fastfetch.settings = {
          modules = [
            "os"
            "host"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "cpu"
            "gpu"
            "memory"
            "swap"
            "disk"
            "localip"
          ];
        };

        fd = {
          hidden = true;
          ignores = [
            ".git/"
            ".jj/"
            ".direnv/"
          ];
        };

        git = {
          userName = "Simon Yde";
          userEmail = "git@simonyde.com";

          aliases = {
            a = "add";
            br = "branch";
            cc = "commit -v";
            ci = "commit -a -v";
            co = "checkout";
            d = "diff";
            st = "status -s";

            ls = ''log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate'';
            ll = ''log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn]" --decorate --numstat'';

            filelog = "log -u";
            fl = "log -u";

            dl = "!git ll -1";

            dr = ''!f() { git diff "$1"^.."$1"; }; f'';

            fixup = "commit --fixup HEAD";
            fix = "rebase -i --autosquash";

            rhh = "reset --hard HEAD";
            alias = "config --get-regexp ^alias\\.";
          };

          extraConfig = {
            init.defaultBranch = "master";

            merge.conflictStyle = "zdiff3";
            push = {
              default = "current";
              autoSetupRemote = true;
            };

            # Rebase
            branch.autosetuprebase = "always";
            pull.rebase = "merges";
            rebase.autostash = true;
            rebase.updateRefs = true;

            commit.verbose = true;
            rerere.enabled = true;

            column.ui = "auto";
            color.ui = "auto";

            diff = {
              colorMoved = "default";
              submodule = "log";
              algorithm = "histogram";
            };

            branch.sort = "-committerdate";
            tag.sort = "-taggerdate";
            log.date = "iso";

            # Signing commits
            gpg.format = "ssh";
            commit.gpgsign = true;
            user.signingkey = "~/.ssh/id_ed25519.pub";

            fetch = {
              prune = true;
              recurseSubmodules = true;
            };

            # Submodules
            submodule.recurse = true;
            push.recurseSubmodules = false;
            status.submoduleSummary = true;

            url = {
              "ssh://git@codeberg.org/".insteadOf = "cb:";
              "ssh://git@github.com/".insteadOf = "gh:";
              "ssh://git@gitlab.com/".insteadOf = "gl:";
              "ssh://git@gitlab.au.dk/".insteadOf = "au:";
            };
          };

          ignores = [
            "**/.idea"
            "**/.metals"
            "**/_build"
            "**/elm-stuff"
            "**/node_modules"
            "**/target"
            "*.log"
            "*.sync-conflict*"
            ".direnv"
            ".env"
            ".envrc"
            "**/.mypy_cache"
            "**/__pycache__"
            "**/.ruff_cache"
            "**/.stfolder"
            "**/.stignore"
            ".vscode"
          ];
        };

        neovim = {
          package = pkgs.neovim;
          defaultEditor = true;

          vimAlias = true;
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

              # ----- Workflow -----
              nvim-lspconfig
              conform-nvim
              trouble-nvim
              diffview-nvim
              neogit
              todo-comments-nvim
              img-clip-nvim
              nvim-ufo

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

        nix-index-database.comma.enable = true;

        nushell = {
          configFile.text = # nu
            ''
              $env.NU_LIB_DIRS ++= [ '${pkgs.nu_scripts}/share/nu_scripts' ]
              source ${config.lib.meta.mkMutableSymlink ../../dotfiles/.config/nushell/my-config.nu}
            '';

          plugins = with pkgs.nushellPlugins; [
            gstat
            query
            formats
            # skim
          ];
        };

        ripgrep.arguments = [
          "--smart-case"
          "--pretty"
        ];

        starship = {
          enableBashIntegration = false;

          settings = {
            add_newline = false;

            format = lib.concatStrings [
              "$username"
              "$hostname"
              "$directory"
              "$nix_shell"
              "$git_branch"
              "$line_break"
              "$character"
            ];

            right_format = lib.concatStrings [
              "$cmd_duration"
              "$rust"
              "$elm"
              "$golang"
              "$ocaml"
              "$java"
              "$scala"
              "$lua"
              "$typst"
              "$direnv"
              "$gleam"
            ];

            # Modules
            character = {
              # success_symbol = "[⟩](normal white)";
              # error_symbol = "[⟩](bold red)";
              success_symbol = "";
              error_symbol = "";
            };

            direnv = {
              format = "[($loaded/$allowed)]($style)";
              disabled = false;
              loaded_msg = "";
              allowed_msg = "";
            };

            directory = {
              style = "bold green";
              fish_style_pwd_dir_length = 1;
            };

            git_branch = {
              symbol = " ";
              style = "bold purple";
            };

            git_status = {
              style = "bold purple";
            };

            hostname = {
              ssh_symbol = "🌐";
            };

            nix_shell = {
              symbol = " ";
              style = "bold blue";
              heuristic = false;
            };

            golang = {
              symbol = " ";
            };

            elm = {
              symbol = " ";
            };

            scala = {
              disabled = true;
              symbol = " ";
            };
          };
        };

        yazi = {
          enableBashIntegration = true;
          enableNushellIntegration = true;

          shellWrapperName = "yy";

          settings = {
            manager = {
              show_hidden = true;
            };
          };

          plugins = {
            sudo = inputs.sudo-yazi;
          };

          keymap = {
            manager.prepend_keymap = [
              # Navigation (colemak-dh)
              {
                on = [ "m" ];
                run = [
                  "leave"
                  "escape --visual --select"
                ];
                desc = "Go back to parent directory";
              }
              {
                on = [ "n" ];
                run = "arrow 1";
                desc = "Move cursor down";
              }
              {
                on = [ "e" ];
                run = "arrow -1";
                desc = "Move cursor up";
              }
              {
                on = [ "i" ];
                run = [
                  "enter"
                  "escape --visual --select"
                ];
                desc = "Enter the child directory";
              }

              {
                on = [ "M" ];
                run = "back";
              }
              {
                on = [ "N" ];
                run = "arrow 5";
              }
              {
                on = [ "E" ];
                run = "arrow -5";
              }
              {
                on = [ "I" ];
                run = "previous";
              }

              # plugins
              {
                on = [ "z" ];
                run = "plugin zoxide";
                desc = "Jump to a directory using zoxide";
              }
              {
                on = [ "Z" ];
                run = "plugin fzf";
                desc = "Jump to a directory, or reveal a file using fzf";
              }

              # Linemode (colemak-dh)
              {
                on = [
                  "j"
                  "s"
                ];
                run = "linemode size";
                desc = "Linemode: size";
              }
              {
                on = [
                  "j"
                  "p"
                ];
                run = "linemode permissions";
                desc = "Linemode: permissions";
              }
              {
                on = [
                  "j"
                  "m"
                ];
                run = "linemode mtime";
                desc = "Linemode: mtime";
              }
              {
                on = [
                  "j"
                  "b"
                ];
                run = "linemode btime";
                desc = "Linemode: btime";
              }
              {
                on = [
                  "j"
                  "o"
                ];
                run = "linemode owner";
                desc = "Linemode: owner";
              }
              {
                on = [
                  "j"
                  "n"
                ];
                run = "linemode none";
                desc = "Linemode: none";
              }

              {
                on = [ "k" ];
                run = "find_arrow";
              }
              {
                on = [ "K" ];
                run = "find_arrow --previous";
              }

              # Goto
              {
                on = [
                  "g"
                  "t"
                ];
                run = "cd /tmp";
                desc = "Go to the temporary directory";
              }

              # NOTE: plugin: sudo.yazi
              {
                on = [
                  "R"
                  "p"
                  "p"
                ];
                run = "plugin sudo -- paste";
                desc = "sudo paste";
              }

              {
                on = [
                  "R"
                  "P"
                ];
                run = "plugin sudo -- paste --force";
                desc = "sudo paste";
              }

              {
                on = [
                  "R"
                  "r"
                ];
                run = "plugin sudo -- rename";
                desc = "sudo rename";
              }

              {
                on = [
                  "R"
                  "p"
                  "l"
                ];
                run = "plugin sudo -- link";
                desc = "sudo link";
              }

              {
                on = [
                  "R"
                  "p"
                  "r"
                ];
                run = "plugin sudo -- link --relative";
                desc = "sudo link relative path";
              }

              {
                on = [
                  "R"
                  "p"
                  "L"
                ];
                run = "plugin sudo -- hardlink";
                desc = "sudo hardlink";
              }

              {
                on = [
                  "R"
                  "a"
                ];
                run = "plugin sudo -- create";
                desc = "sudo create";
              }

              {
                on = [
                  "R"
                  "d"
                ];
                run = "plugin sudo -- remove";
                desc = "sudo trash";
              }

              {
                on = [
                  "R"
                  "D"
                ];
                run = "plugin sudo -- remove --permanently";
                desc = "sudo delete";
              }
            ];

            tasks.prepend_keymap = [
              # colemak-dh
              {
                on = [ "e" ];
                run = "arrow -1";
                desc = "Move cursor up";
              }
              {
                on = [ "n" ];
                run = "arrow 1";
                desc = "Move cursor down";
              }
            ];

            pick.prepend_keymap = [
              {
                on = [ "e" ];
                run = "arrow -1";
                desc = "Move cursor up";
              }
              {
                on = [ "n" ];
                run = "arrow 1";
                desc = "Move cursor down";
              }

              {
                on = [ "E" ];
                run = "arrow -5";
                desc = "Move cursor up 5 lines";
              }
              {
                on = [ "N" ];
                run = "arrow 5";
                desc = "Move cursor down 5 lines";
              }
            ];

            input.prepend_keymap = [
              # Mode
              {
                on = [ "l" ];
                run = "insert";
                desc = "Enter insert mode";
              }
              {
                on = [ "L" ];
                run = [
                  "move -999"
                  "insert"
                ];
                desc = "Move to the BOL; and enter insert mode";
              }

              # Character-wise movement
              {
                on = [ "m" ];
                run = "move -1";
                desc = "Move back a character";
              }
              {
                on = [ "i" ];
                run = "move 1";
                desc = "Move forward a character";
              }

              # Word-wise movement
              {
                on = [ "j" ];
                run = "forward --end-of-word";
                desc = "Move forward to the end of the current or next word";
              }

              # Undo/Redo
              {
                on = [ "u" ];
                run = "undo";
                desc = "Undo the last operation";
              }
              {
                on = [ "U" ];
                run = "redo";
                desc = "Redo the last operation";
              }
            ];

            completion.prepend_keymap = [
              {
                on = [ "<A-e>" ];
                run = "arrow -1";
                desc = "Move cursor up";
              }
              {
                on = [ "<A-n>" ];
                run = "arrow 1";
                desc = "Move cursor down";
              }
            ];

            help.prepend_keymap = [
              # Navigation
              {
                on = [ "e" ];
                run = "arrow -1";
                desc = "Move cursor up";
              }
              {
                on = [ "n" ];
                run = "arrow 1";
                desc = "Move cursor down";
              }

              {
                on = [ "E" ];
                run = "arrow -5";
                desc = "Move cursor up 5 lines";
              }
              {
                on = [ "N" ];
                run = "arrow 5";
                desc = "Move cursor down 5 lines";
              }

              # Filtering
              {
                on = [ "/" ];
                run = "filter";
                desc = "Apply a filter for the help items";
              }
            ];
          };
        };
      };
    }

    (mkIf config.programs.fzf.enable {
      programs.fzf.defaultCommand = "${getExe pkgs.fd} -H --type file";

      home.sessionVariables.COMMA_PICKER = "fzf";
    })

  ];
}

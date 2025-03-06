{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (lib) getExe mkIf mkMerge;
  cfg = config.programs;
in

{
  imports = [ inputs.nix-index-database.hmModules.nix-index ];

  config = mkMerge [
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

        fd = {
          hidden = true;
          ignores = [
            ".git/"
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

        nix-index-database.comma.enable = true;

        nushell = {
          configFile.text = # nu
            ''
              source ~/.config/nushell/my-config.nu
            '';

          plugins = with pkgs.nushellPlugins; [
            gstat
            query
            formats
            skim
          ];
        };

        ripgrep = {
          arguments = [
            "--smart-case"
            "--pretty"
            "--hidden"
            "--glob=!**/.git/*"
          ];
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
                desc = "Set linemode to size";
              }
              {
                on = [
                  "j"
                  "p"
                ];
                run = "linemode permissions";
                desc = "Set linemode to permissions";
              }
              {
                on = [
                  "j"
                  "m"
                ];
                run = "linemode mtime";
                desc = "Set linemode to mtime";
              }
              {
                on = [
                  "j"
                  "n"
                ];
                run = "linemode none";
                desc = "Set linemode to none";
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

              {
                on = [ "<S-Up>" ];
                run = "arrow -5";
                desc = "Move cursor up 5 lines";
              }
              {
                on = [ "<S-Down>" ];
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

              {
                on = [ "<S-Up>" ];
                run = "arrow -5";
                desc = "Move cursor up 5 lines";
              }
              {
                on = [ "<S-Down>" ];
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

        zellij.enableBashIntegration = false;
      };
    }

    (mkIf cfg.bat.enable {
      programs.bat = {
        config = {
          pager = "less -FR";
        };
        extraPackages = with pkgs.bat-extras; [
          batdiff
          batman
          batgrep
          batwatch
        ];
      };

      programs.nushell.shellAliases = {
        cat = "bat";
        man = "batman";
      };
    })

    (mkIf cfg.fzf.enable {
      programs.fzf =
        let
          fd = getExe pkgs.fd;
        in
        {
          changeDirWidgetCommand = "${fd} -H --type directory";
          fileWidgetCommand = "${fd} -H --type file";
          defaultCommand = "${fd} -H --type file";
        };

      home.sessionVariables.COMMA_PICKER = "fzf";
    })

    (mkIf cfg.starship.enable {
      programs.starship.settings = {
        add_newline = false;
        format = "$username$hostname$directory$nix_shell$git_branch$line_break$character";
        right_format = "$cmd_duration$rust$elm$golang$ocaml$java$scala$lua$typst$direnv$gleam";

        character = {
          success_symbol = "[⟩](normal white)";
          error_symbol = "[⟩](bold red)";
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

        username = {
          format = "[$user]($style)";
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
          symbol = " ";
          disabled = true;
        };
      };

      programs.nushell.environmentVariables = {
        PROMPT_INDICATOR = "";
        PROMPT_INDICATOR_VI_INSERT = "";
        PROMPT_INDICATOR_VI_NORMAL = "";
        PROMPT_MULTILINE_INDICATOR = "";
      };
    })
  ];
}

{ pkgs, ... }:

{
  programs.yazi = {
    enableBashIntegration = true;
    enableNushellIntegration = true;

    shellWrapperName = "yy";

    settings = {
      opener.extract = [
        {
          run = ''ouch d -y "$@"'';
          desc = "Extract here with ouch";
          for = "unix";
        }
      ];
      plugin = {
        prepend_previewers = [
          # Archive previewer
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --archive-icon='🗄️ ' --show-file-icons";
          }
        ];
      };

      mgr = {
        show_hidden = true;
      };
    };

    plugins = { inherit (pkgs.yaziPlugins) sudo ouch; };

    keymap = {
      mgr.prepend_keymap = [
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

        # plugins
        {
          on = [ "C" ];
          run = "plugin ouch";
          desc = "Compress with ouch";
        }

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
}

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = config.programs.yazi;
in
{

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      poppler
      ueberzugpp
    ];
    programs.yazi = {
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      shellWrapperName = "yy";
      settings = {
        manager = {
          show_hidden = true;
        };
      };
      plugins = {
        bookmarks = inputs.bookmarks-yazi;
      };
      initLua = # lua
        ''
          require("bookmarks"):setup({
              last_directory = { enable = false, persist = false },
              persist = "vim",
              desc_format = "parent",
              file_pick_mode = "hover",
              notify = {
                  enable = false,
                  timeout = 1,
                  message = {
                      new = "New bookmark '<key>' -> '<folder>'",
                      delete = "Deleted bookmark in '<key>'",
                      delete_all = "Deleted all bookmarks",
                  },
              },
          })
        '';
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
          {
            on = [ "h" ];
            run = "plugin bookmarks --args=save";
            desc = "Save current position as a bookmark";
          }
          {
            on = [ "'" ];
            run = "plugin bookmarks --args=jump";
            desc = "Jump to a bookmark";
          }
          {
            on = [
              "b"
              "d"
            ];
            run = "plugin bookmarks --args=delete";
            desc = "Delete a bookmark";
          }
          {
            on = [
              "b"
              "D"
            ];
            run = "plugin bookmarks --args=delete_all";
            desc = "Delete all bookmarks";
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

        select.prepend_keymap = [
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
  };
}

{ config, pkgs, ... }:
let
  flavour = config.themes.flavour;
  catppuccin = config.themes.catppuccin;
in
{
  programs.zellij = {
    package = pkgs.unstable.zellij;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;

    # settings = {
    #   theme = "catppuccin";
    #   themes.catppuccin = with catppuccin.${flavour}; {
    #     bg = surface2;
    #     fg = text;
    #     red = red;
    #     green = green;
    #     blue = blue;
    #     yellow = yellow;
    #     magenta = mauve;
    #     orange = peach;
    #     cyan = teal;
    #     black = mantle;
    #     white = text;
    #   };
    #   default_layout = "compact";
    #   default_shell = "fish";
    #   simplified_ui = false;
    #   pane_frames = false;
    # };
  };
  home.file."${config.xdg.configHome}/zellij/config.kdl".text = with catppuccin.${flavour}; ''
    theme "catppuccin"
    themes {
      catppuccin {
        bg "${surface2}"
        fg "${text}"
        red "${red}"
        green "${green}"
        blue "${blue}"
        yellow "${yellow}"
        magenta "${mauve}"
        orange "${peach}"
        cyan "${teal}"
        black "${mantle}"
        white "${text}"
      }
    }
    // default_layout "compact"
    default_shell "fish"
    simplified_ui false
    pane_frames false
    mouse_mode true

    keybinds clear-defaults=true {
      normal {
        bind "F1" { GoToTab 1; }
        bind "F2" { GoToTab 2; }
        bind "F3" { GoToTab 3; }
        bind "F4" { GoToTab 4; }
        bind "F5" { GoToTab 5; }
        bind "F6" { GoToTab 6; }
        bind "F7" { GoToTab 7; }
        bind "F8" { GoToTab 8; }
        bind "F9" { GoToTab 9; }
        bind "F10" { GoToTab 10; }
        bind "F11" { GoToTab 11; }
        bind "F12" { GoToTab 12; }
      }

      locked {
        bind "Ctrl l" { SwitchToMode "normal"; }
      }

      resize {
        bind "Ctrl y" { SwitchToMode "Normal"; }
        bind "m" "Left" { Resize "Increase Left"; }
        bind "n" "Down" { Resize "Increase Down"; }
        bind "e" "Up" { Resize "Increase Up"; }
        bind "i" "Right" { Resize "Increase Right"; }
        bind "M" { Resize "Decrease Left"; }
        bind "N" { Resize "Decrease Down"; }
        bind "E" { Resize "Decrease Up"; }
        bind "I" { Resize "Decrease Right"; }
        bind "=" "+" { Resize "Increase"; }
        bind "-" { Resize "Decrease"; }
      }

      pane {
        bind "Ctrl q" { SwitchToMode "normal"; }
        bind "q" { SwitchFocus; }
        bind "m" "Left" { MoveFocus "Left"; }
        bind "n" "Down" { MoveFocus "Down"; }
        bind "e" "Up" { MoveFocus "Up"; }
        bind "i" "Right" { MoveFocus "Right"; }
        bind "k" { NewPane; SwitchToMode "Normal"; }
        bind "s" { NewPane "Down"; SwitchToMode "Normal"; }
        bind "v" { NewPane "Right"; SwitchToMode "Normal"; }
        bind "x" { CloseFocus; SwitchToMode "Normal"; }
        bind "r" { SwitchToMode "RenamePane"; PaneNameInput 0; }
        bind "Ctrl e" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
        bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
        bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
        bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
      }

      tab {
        bind "Ctrl t" { SwitchToMode "Normal"; }
        bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
        bind "m" "Left" "Up" { GoToPreviousTab; }
        bind "i" "Right" "Down" { GoToNextTab; }
        bind "n" { NewTab; SwitchToMode "Normal"; }
        bind "x" { CloseTab; SwitchToMode "Normal"; }
        bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
        bind "b" { BreakPane; SwitchToMode "Normal"; }
        bind "]" { BreakPaneRight; SwitchToMode "Normal"; }
        bind "[" { BreakPaneLeft; SwitchToMode "Normal"; }
        bind "1" { GoToTab 1; SwitchToMode "Normal"; }
        bind "2" { GoToTab 2; SwitchToMode "Normal"; }
        bind "3" { GoToTab 3; SwitchToMode "Normal"; }
        bind "4" { GoToTab 4; SwitchToMode "Normal"; }
        bind "5" { GoToTab 5; SwitchToMode "Normal"; }
        bind "6" { GoToTab 6; SwitchToMode "Normal"; }
        bind "7" { GoToTab 7; SwitchToMode "Normal"; }
        bind "8" { GoToTab 8; SwitchToMode "Normal"; }
        bind "9" { GoToTab 9; SwitchToMode "Normal"; }
        bind "0" { GoToTab 10; SwitchToMode "Normal"; }
        bind "Tab" { ToggleTab; }
      }

      scroll {
        bind "Ctrl s" { SwitchToMode "Normal"; }
        bind "Ctrl e" { EditScrollback; SwitchToMode "Normal"; }
        bind "s" { SwitchToMode "EnterSearch"; SearchInput 0; }
        bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
        bind "n" "Down" { ScrollDown; }
        bind "e" "Up" { ScrollUp; }
        bind "i" "Right" "PageDown" { PageScrollDown; }
        bind "m" "Left" "PageUp" { PageScrollUp; }
        bind "d" { HalfPageScrollDown; }
        bind "u" { HalfPageScrollUp; }
      }

      search {
        bind "Ctrl s" { SwitchToMode "Normal"; }
        bind "Ctrl c" { ScrollToBottom; SwitchToMode "Normal"; }
        bind "n" "Down" { ScrollDown; }
        bind "k" "Up" { ScrollUp; }
        bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
        bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
        bind "d" { HalfPageScrollDown; }
        bind "u" { HalfPageScrollUp; }
        bind "k" { Search "down"; }
        bind "K" { Search "up"; }
        bind "c" { SearchToggleOption "CaseSensitivity"; }
        bind "w" { SearchToggleOption "Wrap"; }
        bind "o" { SearchToggleOption "WholeWord"; }
      }

      entersearch {
        bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
        bind "Enter" { SwitchToMode "Search"; }
      }

      renametab {
        bind "Ctrl c" { SwitchToMode "Normal"; }
        bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
      }

      renamepane {
        bind "Ctrl c" { SwitchToMode "Normal"; }
        bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
      }

      session {
        bind "Ctrl f" { SwitchToMode "Normal"; }
        bind "Ctrl s" { SwitchToMode "Scroll"; }
        bind "d" { Detach; }
        bind "w" {
          LaunchOrFocusPlugin "zellij:session-manager" {
            floating true
            move_to_focused_tab true
          };
          SwitchToMode "Normal"
        }
      }

      shared_except "normal" "locked" {
        bind "Enter" "Esc" { SwitchToMode "Normal"; }
      }

      shared_except "locked" {
        bind "Ctrl l" { SwitchToMode "locked"; }
      }

      shared_except "pane" "locked" {
        bind "Ctrl q" { SwitchToMode "Pane"; }
      }

      shared_except "resize" "locked" {
        bind "Ctrl y" { SwitchToMode "Resize"; }
      }

      shared_except "scroll" "locked" {
        bind "Ctrl s" { SwitchToMode "Scroll"; }
      }

      shared_except "session" "locked" {
        bind "Ctrl f" { SwitchToMode "Session"; }
      }

      shared_except "tab" "locked" {
        bind "Ctrl t" { SwitchToMode "Tab"; }
      }

    }
  '';
}

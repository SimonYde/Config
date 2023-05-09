{ pkgs, ... }:

{
  programs.helix = {
    package = pkgs.unstable.helix;
    settings = {
      theme = "monokai_pro_spectrum";
      editor.scrolloff = 8;
      editor.true-color = true;
      editor.line-number = "relative";
      editor.indent-guides = {
        render = true;
        character = "▏";
      }; 
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      editor.lsp.display-messages = true;
      editor.bufferline = "multiple";
      editor.color-modes = true;
      editor.statusline = {
        left = [ "mode" "separator" "spinner" "spacer" "file-name" ];
        right = [ "selections" "position-percentage" "position" ];
      };
      keys.normal = {
        X = "extend_line_above"; 
      };
    };
    languages = [
      {
        name = "rust";
        auto-format = true;
        config = { checkOnSave = { command = "clippy"; }; };
      }
      {
        name = "latex";
        soft-wrap = { enable = true; };
        config = {
          texlab = {
            build = {
              executable = "tectonic";
              args = [ "%f" "--synctex" ];
              onSave = true;
              forwardSearchAfter = true;
            };
            forwardSearch = {
              executable = "zathura";
              # args = [ "--synctex-forward" "%l:1:%f" "%p" ];
            };
            chktex = { onEdit = true; };
          };
        };
      }
    ];
  };
}

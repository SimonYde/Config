{ config, ... }:
let
  colors = config.syde.theming.palette-hex;
  cursorline = "#2a2b3c";
  secondary_cursor = "#b5a6a8";
  secondary_cursor_normal = "#878ec0";
  secondary_cursor_insert = "#7da87e";
  overlay0 = "#6c7086";
  overlay1 = "#7f849c";
  overlay2 = "#9399b2";
  subtext0 = "#a6adc8";
in
{
  programs.helix = {
    defaultEditor = false;
    themes.base16 = with colors; {
      "type" = "${base0A}";

      "constructor" = "${base0D}";

      "constant" = "${base09}";
      "constant.builtin" = "${base09}";
      "constant.character" = "${base0C}";
      "constant.character.escape" = "${base0F}";

      "string" = "${base0B}";
      "string.regexp" = "${base09}";
      "string.special" = "${base0D}";

      "comment" = {
        fg = "${overlay1}";
        modifiers = [ "italic" ];
      };

      "variable" = "${base05}";
      "variable.parameter" = {
        fg = "${base09}";
        modifiers = [ "italic" ];
      };
      "variable.builtin" = "${base07}";
      "variable.other.member" = "${base07}";

      "label" = "${base0E}"; # used for lifetimes;

      "punctuation" = "${overlay2}";
      "punctuation.special" = "${base0C}";

      "keyword" = "${base0E}";
      "keyword.storage.modifier.ref" = "${base0C}";
      "keyword.control.conditional" = {
        fg = "${base0E}";
        modifiers = [ "italic" ];
      };

      "operator" = "${base0C}";

      "function" = "${base0D}";
      "function.macro" = "${base0E}";
      "tag" = "${base0E}";
      "attribute" = "${base0A}";
      "namespace" = {
        fg = "${base0D}";
        modifiers = [ "italic" ];
      };
      "special" = "${base0D}"; # fuzzy highlight

      "markup.bold" = {
        modifiers = [ "bold" ];
      };
      "markup.heading.2" = "${base07}";
      "markup.heading.3" = "${base0E}";
      "markup.heading.4" = "${base0B}";
      "markup.heading.5" = "${base0A}";
      "markup.heading.6" = "${base09}";
      "markup.heading.7" = "${base0C}";
      "markup.heading.marker" = {
        fg = "${base09}";
        modifiers = [ "bold" ];
      };
      "markup.italic" = {
        modifiers = [ "italic" ];
      };
      "markup.link.text" = "${base0D}";
      "markup.link.url" = {
        fg = "${base06}";
        modifiers = [ "underlined" ];
      };
      "markup.list" = "${base0E}";
      "markup.raw" = "${base0F}";
      "markup.strikethrough" = {
        modifiers = [ "crossed_out" ];
      };

      "diff.delta" = "${base0A}";
      "diff.minus" = "${base08}";
      "diff.plus" = "${base0B}";

      # User Interface
      # --------------
      # "ui.cursor.match" = { fg = "#${base0A}"; modifiers = [ "underlined" ]; };
      # "ui.popup" = { modifiers  [ "reversed" ]; };

      "ui.background" = {
        fg = "${base05}";
        bg = "none";
      };
      "ui.linenr" = {
        fg = "${base04}";
      };
      "ui.linenr.selected" = {
        fg = "${base07}";
      };
      "ui.statusline" = {
        fg = "${base05}";
        bg = "${base01}";
      };
      "ui.statusline.inactive" = {
        fg = "${base04}";
        bg = "${base01}";
      };
      "ui.statusline.normal" = {
        fg = "${base00}";
        bg = "${base07}";
        modifiers = [ "bold" ];
      };
      "ui.statusline.insert" = {
        fg = "${base00}";
        bg = "${base0B}";
        modifiers = [ "bold" ];
      };
      "ui.statusline.select" = {
        fg = "${base00}";
        bg = "${base0F}";
        modifiers = [ "bold" ];
      };

      "ui.popup" = {
        fg = "${base05}";
        bg = "${base00}";
      };
      "ui.window" = {
        fg = "${base01}";
      }; # crust originally
      "ui.help" = {
        fg = "${overlay2}";
        bg = "none";
      };

      "ui.bufferline" = {
        fg = "${subtext0}";
        bg = "${base01}";
      };
      "ui.bufferline.active" = {
        fg = "${base0E}";
        bg = "${base00}";
        underline = {
          color = "${base0E}";
          style = "line";
        };
      };
      "ui.bufferline.background" = {
        bg = "${base01}";
      };

      "ui.text" = "${base05}";
      "ui.text.focus" = {
        fg = "${base05}";
        bg = "${base03}";
        modifiers = [ "bold" ];
      };
      "ui.text.inactive" = {
        fg = "${overlay1}";
      };

      "ui.virtual" = "${overlay0}";
      "ui.virtual.ruler" = {
        bg = "${base03}";
      };
      "ui.virtual.indent-guide" = "${base03}";
      "ui.virtual.inlay-hint" = {
        fg = "${base04}";
        bg = "${base01}";
      };

      "ui.selection" = {
        bg = "${base04}";
      };

      "ui.cursor" = {
        fg = "${base00}";
        bg = "${secondary_cursor}";
      };
      "ui.cursor.primary" = {
        fg = "${base00}";
        bg = "${base06}";
      };
      "ui.cursor.match" = {
        fg = "${base09}";
        modifiers = [ "bold" ];
      };

      "ui.cursor.primary.normal" = {
        fg = "${base00}";
        bg = "${base06}";
      };
      "ui.cursor.primary.insert" = {
        fg = "${base00}";
        bg = "${base0B}";
      };
      "ui.cursor.primary.select" = {
        fg = "${base00}";
        bg = "${base0F}";
      };

      "ui.cursor.normal" = {
        fg = "${base00}";
        bg = "${secondary_cursor_normal}";
      };
      "ui.cursor.insert" = {
        fg = "${base00}";
        bg = "${secondary_cursor_insert}";
      };
      "ui.cursor.select" = {
        fg = "${base00}";
        bg = "${secondary_cursor}";
      };

      "ui.cursorline.primary" = {
        bg = "${cursorline}";
      };

      "ui.highlight" = {
        bg = "${base04}";
        modifiers = [ "bold" ];
      };

      "ui.menu" = {
        fg = "${overlay2}";
        bg = "${base02}";
      };
      "ui.menu.selected" = {
        fg = "${base05}";
        bg = "${base04}";
        modifiers = [ "bold" ];
      };

      "diagnostic.error" = {
        underline = {
          color = "${base08}";
          style = "curl";
        };
      };
      "diagnostic.warning" = {
        underline = {
          color = "${base0A}";
          style = "curl";
        };
      };
      "diagnostic.info" = {
        underline = {
          color = "${base0C}";
          style = "curl";
        };
      };
      "diagnostic.hint" = {
        underline = {
          color = "${base0C}";
          style = "curl";
        };
      };

      error = "${base08}";
      hint = "${base0C}";
      info = "${base0C}";
      warning = "${base0A}";
    };
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    types
    mkEnableOption
    mkPackageOption
    mkIf
    ;
  theming = config.syde.theming;
  cfg = config.syde.programs.discord;
in
{
  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
      cfg.betterDiscordCtlPackage
    ];

    xdg.configFile."BetterDiscord/themes/base16.theme.css" = {
      enable = theming.enable;
      text =
        with theming.palette-hex; # css
        ''
          /**
           * @name base16-theme
           * @author SimonYde
           * @description base16 theme
           * @version 1.0.0
          */
          :root {
              --base00: ${base00}; /* Black */
              --base01: ${base01}; /* Bright Black */
              --base02: ${base02}; /* Grey */
              --base03: ${base03}; /* Brighter Grey */
              --base04: ${base04}; /* Bright Grey */
              --base05: ${base05}; /* White */
              --base06: ${base06}; /* Brighter White */
              --base07: ${base07}; /* Bright White */
              --base08: ${base08}; /* Red */
              --base09: ${base09}; /* Orange */
              --base0A: ${base0A}; /* Yellow */
              --base0B: ${base0B}; /* Green */
              --base0C: ${base0C}; /* Cyan */
              --base0D: ${base0D}; /* Blue */
              --base0E: ${base0E}; /* Purple */
              --base0F: ${base0F}; /* Magenta */

              --primary-630: ${base00}; /* Autocomplete background */
              --primary-660: ${base00}; /* Search input background */
          }

          .theme-light, .theme-dark {
              --search-popout-option-fade: none; /* Disable fade for search popout */
              --bg-overlay-2: ${base00}; /* These 2 are needed for proper threads coloring */
              --home-background: ${base00};
              --bg-overlay-chat : ${base00}; /* Recolor forum channels */
              --background-primary: ${base00};
              --background-secondary: ${base01};
              --background-secondary-alt: ${base01};
              --channeltextarea-background: ${base01};
              --background-tertiary: ${base00};
              --background-accent: ${base0E};
              --background-floating: ${base01};
              --background-modifier-hover: ${base00}4c;
              --background-modifier-selected: ${base00};
              --text-normal: ${base05};
              --text-secondary: ${base03};
              --text-muted: ${base04};
              --text-link: ${base0C};
              --interactive-normal: ${base05};
              --interactive-hover: ${base05};
              --interactive-active: ${base07};
              --interactive-muted: ${base03};
              --channels-default: ${base04};
              --channel-icon: ${base04};
              --header-primary: ${base06};
              --header-secondary: ${base04};
              --scrollbar-thin-track: transparent;
              --scrollbar-auto-track: transparent;
          }
        '';
    };
  };

  options.syde.programs.discord = {
    enable = mkEnableOption "Discord";

    package = mkPackageOption pkgs "discord" { };

    betterDiscordCtlPackage = mkPackageOption pkgs "betterdiscordctl" { };
    plugins = mkOption {
      default = [ ];
      description = "Optional BetterDiscord plugins.";
      type = types.listOf types.package;
    };

  };
}

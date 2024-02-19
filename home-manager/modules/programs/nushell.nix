{ config, ... }:
{
  programs.nushell = {
    configFile.text = with config.colorScheme.palette; ''
      let $config = {
        table: {
          mode: "rounded"
          green: "${base0B}"
          red: "${base08}"
          yellow: "${base0A}"
          blue: "${base0D}"
          purple: "${base0E}"
          cyan: "${base0C}"
          white: "${base05}"
          black: "${base01}"
          dark_gray: "${base02}"
          light_gray: "${base03}"
        }
        color: {
          green: "${base0B}"
          red: "${base08}"
          yellow: "${base0A}"
          blue: "${base0D}"
          purple: "${base0E}"
          cyan: "${base0C}"
          white: "${base05}"
          black: "${base01}"
          dark_gray: "${base02}"
          light_gray: "${base03}"
        }
      }
    '';
  };
}

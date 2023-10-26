{ config, pkgs, ... }:

let 

  flavour    = config.themes.flavour;
  catppuccin = config.themes.catppuccin;
in
{
  programs.nushell = {
    configFile.text = with catppuccin."${flavour}"; ''
      let $config = {
        table: {
          mode: "rounded"
          green: "${green}"
          red: "${red}"
          yellow: "${yellow}"
          blue: "${blue}"
          purple: "${mauve}"
          cyan: "${teal}"
          white: "${text}"
          black: "${mantle}"
          dark_gray: "${surface0}"
          light_gray: "${surface1}"
        }
        color: {
          green: "${green}"
          red: "${red}"
          yellow: "${yellow}"
          blue: "${blue}"
          purple: "${mauve}"
          cyan: "${teal}"
          white: "${text}"
          black: "${mantle}"
          dark_gray: "${surface0}"
          light_gray: "${surface1}"
        }
      }
    '';
  };
}

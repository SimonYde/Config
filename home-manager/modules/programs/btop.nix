{ config, lib, ... }:

let
  cfg = config.programs.btop;
in
{
  config = lib.mkIf cfg.enable {
    programs.btop = {
      settings = {
        color_theme = "custom_base16.theme";
        theme_background = false;
      };
    };

    xdg.configFile = {
      "btop/themes/custom_base16.theme".text = with config.syde.theming.palette_with_hex; ''
        # Main background, empty for terminal default, need to be empty if you want transparent background
        theme[main_bg]="${base00}"

        # Main text color
        theme[main_fg]="${base05}"

        # Title color for boxes
        theme[title]="${base05}"

        # Highlight color for keyboard shortcuts
        theme[hi_fg]="${base0D}"

        # Background color of selected item in processes box
        theme[selected_bg]="${base03}"

        # Foreground color of selected item in processes box
        theme[selected_fg]="${base0D}"

        # Color of inactive/disabled text
        theme[inactive_fg]="${base04}"

        # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
        theme[graph_text]="${base06}"

        # Background color of the percentage meters
        theme[meter_bg]="${base03}"

        # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
        theme[proc_misc]="${base06}"

        # CPU, Memory, Network, Proc box outline colors
        theme[cpu_box]="${base0E}"
        theme[mem_box]="${base0B}"
        theme[net_box]="${base0F}"
        theme[proc_box]="${base0D}"

        # Box divider line and small boxes line color
        theme[div_line]="${base04}"

        # Temperature graph color
        theme[temp_start]="${base0B}"
        theme[temp_mid]="${base0A}"
        theme[temp_end]="${base08}"

        # CPU graph colors
        theme[cpu_start]="${base0C}"
        theme[cpu_mid]="${base0D}"
        theme[cpu_end]="${base07}"

        # Mem/Disk free meter
        theme[free_start]="${base0E}"
        theme[free_mid]="${base07}"
        theme[free_end]="${base0D}"

        # Mem/Disk cached meter
        theme[cached_start]="${base0D}"
        theme[cached_mid]="${base0D}"
        theme[cached_end]="${base07}"

        # Mem/Disk available meter
        theme[available_start]="${base09}"
        theme[available_mid]="${base0F}"
        theme[available_end]="${base08}"

        # Mem/Disk used meter
        theme[used_start]="${base0B}"
        theme[used_mid]="${base0C}"
        theme[used_end]="${base0C}"

        # Download graph colors
        theme[download_start]="${base09}"
        theme[download_mid]="${base0F}"
        theme[download_end]="${base08}"

        # Upload graph colors
        theme[upload_start]="${base0B}"
        theme[upload_mid]="${base0C}"
        theme[upload_end]="${base07}"

        # Process box color gradient for threads, mem and cpu usage
        theme[process_start]="${base0D}"
        theme[process_mid]="${base0C}"
        theme[process_end]="${base0E}"
      '';
    };
  };
}

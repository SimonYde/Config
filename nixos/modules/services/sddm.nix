{ config, lib, pkgs, inputs, ... }:

let cfg = config.services.xserver.displayManager.sddm; in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      inputs.sddm-catppuccin.packages.${pkgs.hostPlatform.system}.sddm-catppuccin
    ];

    services.xserver.displayManager = {
      autoLogin = {
        user = "syde";
        enable = true;
      };
      sddm = {
        wayland.enable =
          # TODO: add more wayland WM/DE options
          config.programs.sway.enable || config.programs.hyprland.enable;
        theme = "catppuccin";
      };
    };
  };
}

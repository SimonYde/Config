{ lib, pkgs, ... }:
let
  inherit (lib) mkForce;
in
{
  config = {
    # Personal modules
    syde = {
      gui.enable = true;
      programming.enable = true;
      ssh.enable = true;
      terminal.enable = true;
      theming.enable = true;
      desktop.cosmic.enable = false;
    };

    services.blanket.enable = true;
    programs = {
      swaylock.enable = mkForce false;
      hyprlock.enable = mkForce true;
    };

    home.packages = with pkgs; [
      keymapp
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        input = {
          kb_layout = mkForce "eu";
          kb_options = mkForce "";
        };
      };
      extraConfig = # hyprlang
        ''
          workspace=1, monitor:DP-1, default:true
          workspace=2, monitor:DP-1
          workspace=3, monitor:DP-1
          workspace=4, monitor:DP-1
          workspace=5, monitor:DP-1
          workspace=6, monitor:DP-1

          workspace=7, monitor:HDMI-A-1, default:true
          workspace=8, monitor:HDMI-A-1
          workspace=9, monitor:DP-3, default:true
          workspace=10, monitor:DP-3
        '';
    };
  };

  imports = [ ../standard.nix ];
}

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
    };
  };

  imports = [ ../standard.nix ];
}

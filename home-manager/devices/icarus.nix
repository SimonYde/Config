{ lib, pkgs, ... }:
let
  inherit (lib) mkForce;
in
{
  config = {
    # Personal modules
    syde = {
      email.enable = false;
      gui.enable = true;
      programming.enable = true;
      ssh.enable = true;
      terminal.enable = true;
      theming.enable = true;
      desktop.cosmic.enable = false;
    };

    services.blanket.enable = true;
    programs = {
      swaylock.enable = mkForce true;
      hyprlock.enable = mkForce false;
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

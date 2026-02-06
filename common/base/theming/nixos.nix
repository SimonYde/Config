{
  username,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./shared.nix
  ];

  stylix.targets = {
    nixos-icons.enable = true;
    gnome-text-editor.enable = false;
    gnome.enable = false;
  };

  fonts.packages = with pkgs; [
    atkinson-hyperlegible-next
    atkinson-monolegible
    corefonts
    font-awesome
    gentium
    libertinus
    newcomputermodern
    roboto
    source-sans
  ];

  # Don't mess with brave settings
  programs.chromium.enable = lib.mkForce false;

  specialisation."light-theme".configuration = {
    environment.etc."specialisation".text = "light-theme";
    stylix = {
      base16Scheme = lib.mkForce "${inputs.tinted-schemes}/base24/catppuccin-latte.yaml";
      override = lib.mkForce { };
    };
    home-manager.users.${username} = {
      xdg.dataFile."home-manager/specialisation".text = "light-theme";
      programs.hyprlock.settings.label.shadow_passes = lib.mkForce 0;
    };
  };

  home-manager.users.${username}.imports = [ ./home.nix ];
  home-manager.users.root.stylix.enable = false;
}

{
  username,
  inputs,
  lib,
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
  };

  specialisation."light-theme".configuration = {
    environment.etc."specialisation".text = "light-theme";
    environment.etc."light-theme".text = "light-theme";
    stylix = {
      base16Scheme = lib.mkForce "${inputs.tinted-schemes}/base16/gruvbox-light-medium.yaml";
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

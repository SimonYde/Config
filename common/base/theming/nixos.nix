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
    nixos-icons.enable = false;
    gnome-text-editor.enable = false;
  };

  specialisation."light-theme".configuration = {
    environment.etc."light-theme".text = "light-theme";
    stylix = {
      base16Scheme = lib.mkForce "${inputs.tinted-schemes}/base16/gruvbox-light-hard.yaml";
      override = lib.mkForce { };
    };
    home-manager.users.${username} = {
      programs.hyprlock.settings.label.shadow_passes = lib.mkForce 0;
    };
  };

  home-manager.users.${username}.imports = [ ./home.nix ];
}

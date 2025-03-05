{ username, inputs, ... }:

{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./shared.nix
  ];

  home-manager.users.${username}.imports = [ ./home.nix ];
}

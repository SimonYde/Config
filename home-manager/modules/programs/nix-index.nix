{inputs, ...}: {
  config = {
    programs.nix-index-database = {
      comma.enable = true;
    };
  };

  imports = [
    inputs.nix-index-database.hmModules.nix-index
  ];
}

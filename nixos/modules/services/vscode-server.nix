{inputs, config, lib, pkgs, ...}:

{
  config = lib.mkIf config.services.vscode-server.enable {
    programs.nix-ld.enable = true;
    programs.nix-ld.package = pkgs.nix-ld-rs;
  };

  imports = [
    inputs.vscode-server.nixosModules.default
  ];
}

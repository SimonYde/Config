{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.services.vscode-server.enable {
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      git
      wget
    ];
  };

  imports = [ inputs.vscode-server.nixosModules.default ];
}

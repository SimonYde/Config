{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.syde.programming.nix.enable {
    home.packages = with pkgs; [
      inputs.nil.packages.x86_64-linux.nil
      # nil
      # nixd
      # nixpkgs-fmt
      nixfmt-rfc-style
      # alejandra
    ];
  };
  options.syde.programming.nix = {
    enable = lib.mkEnableOption "Nix language tools";
  };
}

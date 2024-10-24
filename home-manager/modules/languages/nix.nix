{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.syde.programming.nix.enable {
    home.packages = with pkgs; [
      # nil
      nixd
      nixfmt-rfc-style
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [ ];
  };
  options.syde.programming.nix = {
    enable = lib.mkEnableOption "Nix language tools";
  };
}

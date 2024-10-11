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
      # nil
      nixd
      # nixpkgs-fmt
      nixfmt-rfc-style
      # alejandra
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      (nvim-treesitter.withPlugins (p: [
        p.nix
      ]))
    ];
  };
  options.syde.programming.nix = {
    enable = lib.mkEnableOption "Nix language tools";
  };
}

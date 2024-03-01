{ pkgs, lib, config, ... }:

let cfg = config.syde.programming.rust; in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      cargo
      rustc
      rust-analyzer
      rustfmt
      clippy
    ];

    programs.neovim.plugins = with pkgs.vimPlugins; [
      rustaceanvim
    ];
  };

  options.syde.programming.rust = with lib; {
    enable = mkEnableOption "Rust programming language support";
  };
}


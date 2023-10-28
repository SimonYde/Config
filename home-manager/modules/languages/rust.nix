{ pkgs, lib, config, ... }:

{
  config = lib.mkIf config.syde.programming.rust.enable {
    home.packages = with pkgs; [
      cargo
      rustc
      rust-analyzer
      rustfmt
      clippy
    ];
  };

  options.syde.programming.rust = with lib; {
    enable = mkEnableOption "Rust programming language support";
  };
}


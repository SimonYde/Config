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
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
}


{ pkgs, lib, config, ... }:

{
  config = lib.mkIf config.syde.programming.python.enable {
    home.packages = with pkgs; [
      (python311.withPackages (ps: with ps; [
        requests
        lxml
      ]))
    ];
  };

  options.syde.programming.python = with lib; {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
}


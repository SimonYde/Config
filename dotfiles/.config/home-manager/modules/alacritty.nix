{ config, pkgs, ... }:

{
  config = {
    programs.alacritty = {
      package =
        pkgs.writeShellScriptBin "alacritty" ''
          #!/bin/sh
          ${pkgs.nixGL.nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
        '';
    };
  };
}

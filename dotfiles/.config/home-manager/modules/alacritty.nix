{ config, pkgs, ... }:

{
  config = {
    programs.alacritty = {
      package =
        pkgs.writeShellScriptBin "alacritty" ''
          #!/bin/sh
          ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${pkgs.alacritty}/bin/alacritty "$@"
        '';
    };
  };
}

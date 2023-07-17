{ pkgs, ... }:
{
  programs.zathura = {
    extraConfig = ''
      include ${pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "zathura";
            rev = "d85d875";
            sha256 = "sha256-5Vh2bVabuBluVCJm9vfdnjnk32CtsK7wGIWM5+XnacM=";
          } + "/src/catppuccin-mocha"}
    '';
  };
}

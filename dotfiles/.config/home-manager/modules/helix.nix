{ pkgs, ... }:
let helix-master = pkgs.unstable.helix.overrideAttrs (old : {
  version = "master";
  src = pkgs.fetchFromGitHub {
    owner = "helix-editor";
    repo = "helix";
    rev = "master";
    sha256 = "sha256-HQihTWnjgGNI8VuRm8sX5CmFXcBMhd8QaFWWNp9kNes=";
  };
});
in 
{
  programs.helix = {
    package = pkgs.unstable.helix;
    # package = helix-master;
  };
}


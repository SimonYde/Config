{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "catppuccin-sddm";
  version = "2024-03-14";
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -r $src/src/* $out/share/sddm/themes/
  '';
  src = fetchFromGitHub {
    owner = "catppuccin";
    repo = "sddm";
    rev = "1a58b5c2d898a70c22e4d9462039111f5613a7c0";
    sha256 = "sha256-cZuNQDXdWiE2eCf/bdGFYKM5SXrENxJere83SI47ol4=";
  };
}

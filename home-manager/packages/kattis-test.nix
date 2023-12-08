{ lib
, stdenv
, fetchFromGitHub
, callPackage
}:

let
  kattis-cli = callPackage ./kattis-cli.nix { };
in
stdenv.mkDerivation {
  pname = "kattis-test";
  version = "unstable-2023-10-17";

  src = fetchFromGitHub {
    owner = "tyilo";
    repo = "kattis-test";
    rev = "024cb044f6e5b0ad2666bc8d544f7a7dc5acfafb";
    hash = "sha256-eFJzbc8FuS3PqueLWuuQvE5MLnNIGxEdRLqboNCSd6s=";
  };

  buildInputs = [ kattis-cli ];

  patchPhase = ''
    substituteInPlace kattis-test \
      --replace '"rustup",' "" \
      --replace '"run",' "" \
      --replace '"1.61.0",' ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp kattis-test $out/bin/kattis-test
  '';

  meta = with lib; {
    description = "Tool for running problem submissions against samples.";
    homepage = "https://github.com/tyilo/kattis-test";
    maintainers = with maintainers; [ ];
    mainProgram = "kattis";
    platforms = platforms.all;
  };
}

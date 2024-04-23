{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
}:
let
  kattis-cli = callPackage ./kattis-cli.nix { };
in
stdenv.mkDerivation {
  pname = "kattis-test";
  version = "unstable-2024-03-16";

  src = fetchFromGitHub {
    owner = "tyilo";
    repo = "kattis-test";
    rev = "89628b7202c4cc2f262deae080f831e229d784b9";
    hash = "sha256-h1RkuOOhb9RZYsD+DSnDH3CQj67Z9v4gi7SwzBvcfr4=";
  };

  buildInputs = [ kattis-cli ];

  patchPhase = ''
    substituteInPlace kattis-test \
      --replace '"rustup",' "" \
      --replace '"run",' "" \
      --replace '"1.72.1",' ""
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

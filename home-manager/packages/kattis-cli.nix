{ lib
, stdenv
, fetchFromGitHub
, python3
}:

let python = python3.pkgs.python.withPackages (ps: with ps; [
  requests
  lxml
]);
in

stdenv.mkDerivation rec {
  pname = "kattis-cli";
  version = "unstable-2023-10-17";

  src = fetchFromGitHub {
    owner = "Kattis";
    repo = "kattis-cli";
    rev = "e5d30f8d7d13983617fdbd5912cef4b3eec3ba03";
    hash = "sha256-LkdZnn+gTS8/I0BJsvC9RKJi7nHBtvKclVu2HtjE++I=";
  };

  propagatedBuildInputs = [ python ];

  installPhase = ''
    mkdir -p $out/bin
    cp submit.py $out/bin/submit.py
    echo "$out/bin/submit.py "$@"" > $out/bin/kattis
    chmod +x $out/bin/kattis
  '';

  meta = with lib; {
    description = "Kattis online judge command line tool";
    homepage = "https://github.com/Kattis/kattis-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "kattis";
    platforms = platforms.all;
  };
}

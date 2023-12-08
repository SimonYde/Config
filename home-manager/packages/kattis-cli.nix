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
    rev = "624fe94515591b42b1545b1b6f027c0333090c41";
    hash = "sha256-rw3u5OwDXx/bc/x9cTSLhd04rGBuBrRDg7WuWyMMAEs=";
  };

  propagatedBuildInputs = [ python ];

  installPhase = ''
    mkdir -p $out/bin
    cp submit.py $out/bin/submit.py
    echo "#!${python}/bin/python3 $out/bin/submit.py "$@"" > $out/bin/kattis
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

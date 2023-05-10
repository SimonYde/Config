{ pkgs, lib, fetchFromGitHub }:

with pkgs.python3Packages;

buildPythonApplication rec {
  pname = "grawlix";
  version = "84dce7c";

  src = fetchFromGitHub {
    owner = "jo1gi";
    repo = pname;
    rev = version;
    sha256 = "sha256-PMdaIzWsydJVOySuOvjucrqppTJRo/2CMS0JT4GfoKY=";
  };

  propagatedBuildInputs = [
    appdirs
    beautifulsoup4
    importlib-resources
    lxml
    pycryptodome
    rich
    tomli
    httpx

    # Build
    setuptools

    (buildPythonPackage rec {
      pname = "EbookLib";
      version = "0.18";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-OFYmQ6e8lNm/VumTC0kn5Ok7XR0JF/aXpkVNtaHBpTM=";
      };
      propagatedBuildInputs = [
        six
        lxml
      ];
    })

    (buildPythonPackage rec {
      pname = "blackboxprotobuf";
      version = "1.0.1";

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-IztxTmwkzp0cILhxRioiCvkXfk/sAcG3l6xauGoeHOo=";
      };

      propagatedBuildInputs = [
        protobuf
      ];

      patchPhase = ''
        sed 's/protobuf==3.10.0/protobuf/' requirements.txt > requirements.txt
      '';

      doCheck = false;
    })

  ];
  doCheck = false;

  meta = with lib; {
    description = "eBook cli downloader";
    homepage = "https://github.com/jo1gi/grawlix";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}

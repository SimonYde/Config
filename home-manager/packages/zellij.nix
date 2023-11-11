{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, protobuf
, curl
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "zellij";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "zellij-org";
    repo = "zellij";
    rev = "v${version}";
    hash = "sha256-ZKtYXUNuBwQtEHTaPlptiRncFWattkkcAGGzbKalJZE=";
  };

  cargoHash = "sha256-4XRCXQYJaYvnIfEK2b0VuLy/HIFrafLrK9BvZMnCKpY=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    curl
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.IOKit
    darwin.apple_sdk.frameworks.Security
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "A terminal workspace with batteries included";
    homepage = "https://github.com/zellij-org/zellij";
    changelog = "https://github.com/zellij-org/zellij/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}

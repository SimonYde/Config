{ fetchFromGitHub, lib, rustPlatform, installShellFiles, makeWrapper, callPackage }:

let
  version = "1adb194";

  src = fetchFromGitHub {
    owner = "helix-editor";
    repo = "helix";
    rev = "${version}";
    hash = "sha256-Hj7wkPwNE9LNG8miDvzobehUBwfecfNl7hFL3ex8Q9Q=";
  };

  grammars = callPackage ( src + "/grammars.nix" ) { };
in 
rustPlatform.buildRustPackage {
  inherit src version;

  pname = "helix";
  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  cargoSha256 = "sha256-wqFhz8bG8cpx6/V/ZcnR6f3OCU4EOdGSomATSS0NkIg="; 

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  postInstall = ''
    # We self build the grammar files
    rm -r runtime/grammars

    mkdir -p $out/lib
    cp -r runtime $out/lib
    ln -s ${grammars} $out/lib/runtime/grammars
    installShellCompletion contrib/completion/hx.{bash,fish,zsh}
    mkdir -p $out/share/{applications,icons/hicolor/256x256/apps}
    cp contrib/Helix.desktop $out/share/applications
    cp contrib/helix.png $out/share/icons/hicolor/256x256/apps
  '';
  postFixup = ''
    wrapProgram $out/bin/hx --set HELIX_RUNTIME $out/lib/runtime
  '';

  # disable fetching and building of tree-sitter grammars in favor of the custom build process in ./grammars.nix
  env.HELIX_DISABLE_AUTO_GRAMMAR_BUILD = "1";

  # passthru.updateScript = ./helix-build-files/update.py;

  meta = with lib; {
    description = "A post-modern modal text editor";
    homepage = "https://helix-editor.com";
    license = licenses.mpl20;
    mainProgram = "hx";
    maintainers = with maintainers; [ danth yusdacra zowoq ];
  };
}

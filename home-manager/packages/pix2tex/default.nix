{
  lib,
  python3,
  fetchFromGitHub,
  callPackage,
}:
let
  x-transformers = callPackage ./x-transformers.nix { };
  timm = callPackage ./timm.nix { };
in
python3.pkgs.buildPythonApplication rec {
  pname = "pix2tex";
  version = "0.0.31";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lukas-blecher";
    repo = "LaTeX-OCR";
    rev = version;
    hash = "sha256-VS7zbrXRrX2nb51zGdhnydZyWuX+yZ6ssU8ZviE9N+Y=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    wheel
    torch
    torchvision
    pandas
    munch
    transformers
    x-transformers
    timm
    einops
    albumentations
    tqdm
    requests
    tokenizers
    numpy
    pyyaml
    pillow
    opencv4

    # GUI
    pyqt6
    pyqt6-webengine
    pynput
    screeninfo
    pyside6
  ];

  patchPhase = ''
    substituteInPlace ./pix2tex/model/checkpoints/get_latest_checkpoint.py \
      --replace "path = os.path.dirname(__file__)" $'path = os.path.join(os.environ["HOME"], ".cache", "pix2tex")\n    if not os.path.exists(path):\n        os.makedirs(path)'
    substituteInPlace ./pix2tex/__main__.py \
      --replace "default='checkpoints/weights.pth'" "default=os.path.join(os.environ['HOME'], '.cache', 'pix2tex', 'weights.pth')" \
      --replace $'    import os\n' "" \
      --replace "def main():" $'def main():\n    import os\n'
  '';

  doCheck = false;
  # pythonImportsCheck = [ "pix2tex" ];

  meta = with lib; {
    description = "Pix2tex: Using a ViT to convert images of equations into LaTeX code";
    homepage = "https://github.com/lukas-blecher/LaTeX-OCR";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "pix2tex";
  };
}

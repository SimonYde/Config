{ pkgs, slug, ... }:

pkgs.writeShellScriptBin "ran_bg" ''
  DIRECTORY=$HOME/Config/assets/backgrounds/${slug}

  # Check if the provided directory exists
  if [ ! -d "$DIRECTORY" ]; then
      echo "Directory does not exist: $DIRECTORY"
      exit 1
  fi

  # Find all image files in the directory and pick one at random
  IMAGES=$(${pkgs.fd}/bin/fd . "$DIRECTORY" -t f)
  IMAGE=$(echo "$IMAGES" | shuf -n1)
  ${pkgs.swww}/bin/swww img "$IMAGE"
''

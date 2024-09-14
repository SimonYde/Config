{ pkgs, slug, homeDirectory, ... }:

pkgs.writeShellScriptBin "rand_bg" ''
  DIRECTORY=${homeDirectory}/Config/assets/backgrounds/${slug}

  # Check if the provided directory exists
  if [ ! -d "$DIRECTORY" ]; then
      echo "Directory does not exist: $DIRECTORY"
      exit 1
  fi

  CURRENT=$(${pkgs.swww}/bin/swww query | awk '{ print $8 }')

  # Find all image files in the directory and pick one at random
  IMAGES=$(${pkgs.fd}/bin/fd . "$DIRECTORY" -E $CURRENT -t f)
  IMAGE=$(echo "$IMAGES" | shuf -n1)
  ${pkgs.swww}/bin/swww img "$IMAGE"
''

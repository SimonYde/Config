{
  writeShellScriptBin,
  nix,
}:
writeShellScriptBin "gc" ''
  # automagically GC all the known profiles
  set -eu

  if [[ $(id -u) -ne 0 && -t 0 ]]; then
    exec sudo $0 $@
  fi

  log() {
    echo -ne '\033[0;32m'
    echo -n $@
    echo -e '\033[0m'
  }

  time=''${1:-old}

  for profile in \
    /home/*/.local/state/nix/profiles/{profile,home-manager} \
    /root/.local/state/nix/profiles/{profile,home-manager} \
    /nix/var/nix/profiles/per-user/*/{profile,home-manager} \
    /nix/var/nix/profiles/{system,default} \
  ; do
    if [ -d $profile ]; then
      log "Cleaning up profile $profile..."
      ${nix}/bin/nix-env --profile $profile --delete-generations $time || true
    fi
  done

  log "Running GC..."
  ${nix}/bin/nix-store --gc
''

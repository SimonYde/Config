{pkgs, ...}: {
  programs.bash = {
    enableCompletion = true;
    historyIgnore = [
      "fg"
      "pkill"
      "kill"
      "rm"
      "rt"
      "trash"
      "rmdir"
      "mkdir"
      "touch"
      "exit"
      "mv"
    ];
  };
}

{pkgs, ...}: {
  programs.zoxide = {
    enableFishIntegration = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };
}

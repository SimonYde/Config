{ ... }:
{
  programs.ripgrep = {
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!**/.git/*"
    ];
  };
}

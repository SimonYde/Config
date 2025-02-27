{ ... }:
{
  programs.ripgrep = {
    arguments = [
      "--smart-case"
      "--pretty"
      "--hidden"
      "--glob=!**/.git/*"
    ];
  };
}

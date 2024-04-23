{ ... }:
{
  programs.ripgrep = {
    arguments = [
      "--hidden"
      "--glob=!**/.git/*"
    ];
  };
}

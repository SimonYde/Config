{ ... }:

{
  config = {
    programs.hyprlock = {
      settings = {
        background = [ { blur_passes = 7; } ];
      };
    };
  };
}

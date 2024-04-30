{inputs, ...}: 

{
  imports = [
    inputs.hyprlock.homeManagerModules.default
  ];

  config = {
    programs.hyprlock = {
      backgrounds = [
      {
        blur_passes = 7;
      }

      ];
    };
  };

}

{ lib, config, ... }:

let
  cfg = config.services.kanata;
in
{
  config = lib.mkIf cfg.enable {
    services.kanata.keyboards.laptop-keyboard = {
      config = # lisp
        ''
          (defsrc
            caps a s d f j k l ;
          )
          (defvar
            tap-time 180
            hold-time 180
          )

          (defalias
            a (tap-hold $tap-time $hold-time a lmet)
            s (tap-hold $tap-time $hold-time s lalt)
            d (tap-hold $tap-time $hold-time d lctl)
            f (tap-hold $tap-time $hold-time f lsft)

            j (tap-hold $tap-time $hold-time j rsft)
            k (tap-hold $tap-time $hold-time k lctl)
            l (tap-hold $tap-time $hold-time l lalt)
            ; (tap-hold $tap-time $hold-time ; rmet)
          )


          (deflayer default-layer
            esc @a @s @d @f @j @k @l @;
          )
        '';
      extraDefCfg = "process-unmapped-keys yes";
      devices = [
        "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
      ];
    };
  };
}

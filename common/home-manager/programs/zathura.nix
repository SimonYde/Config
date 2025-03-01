{ config, lib, ... }:
let
  cfg = config.programs.zathura;
in
{
  config = lib.mkIf cfg.enable {
    programs.zathura = { };
    xdg.mimeApps = {
      associations.added = {
        "application/pdf" = [
          "org.pwmt.zathura-pdf-mupdf.desktop"
          "org.pwmt.zathura.desktop"
        ];
      };
      defaultApplications = {
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
  };
}

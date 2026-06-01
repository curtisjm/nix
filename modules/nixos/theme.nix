{
  config,
  lib,
  pkgs,
  ...
}:
let
  themes = import ../../themes { inherit lib pkgs; };
  cfg = config.custom.theme;
in
{
  options.custom.theme = {
    enable = lib.mkEnableOption "custom theming";

    colorScheme = lib.mkOption {
      type = lib.types.enum (builtins.attrNames themes);
      default = "nord";
      description = "Theme to apply at rebuild time.";
    };

    transparency = lib.mkEnableOption "transparency and blur effects";

    themes = lib.mkOption {
      type = lib.types.attrsOf lib.types.attrs;
      default = themes;
      readOnly = true;
      description = "Available system themes.";
    };

    current = lib.mkOption {
      type = lib.types.attrs;
      default = cfg.themes.${cfg.colorScheme};
      readOnly = true;
      description = "Selected system theme data.";
    };
  };
}

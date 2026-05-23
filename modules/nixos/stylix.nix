{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.theme;
  theme = cfg.current;
in
{
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      stylix.enable = true;
      stylix.polarity = "dark";

      stylix.image = theme.stylix.image;
      stylix.base16Scheme = theme.stylix.base16Scheme;
      stylix.fonts = theme.stylix.fonts;
    }

    (lib.mkIf (theme.stylix ? cursor) {
      stylix.cursor = theme.stylix.cursor;
    })
  ]);
}

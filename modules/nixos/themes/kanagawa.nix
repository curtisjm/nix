{ pkgs, mkTheme }:
mkTheme {
  name = "kanagawa";
  displayName = "Kanagawa";

  stylix = {
    image = ../../../wallpapers/kanagawa-1.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  apps.neovim = {
    name = "tokyonight";
    style = "moon";
  };
}

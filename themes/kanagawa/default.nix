{ pkgs, mkTheme }:
mkTheme {
  name = "kanagawa";
  displayName = "Kanagawa";

  stylix = {
    image = ./wallpapers/kanagawa-1.png;
    base16Scheme = ./base16.yaml;
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

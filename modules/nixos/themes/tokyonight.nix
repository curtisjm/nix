{ pkgs, mkTheme }:
mkTheme {
  name = "tokyonight";
  displayName = "Tokyo Night Moon";

  stylix = {
    image = ../../../wallpapers/tokyonight-2.png;
    base16Scheme = ../../../themes/tokyo-night-moon-bright.yaml;
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

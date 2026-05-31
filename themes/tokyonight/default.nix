{ pkgs, mkTheme }:
mkTheme {
  name = "tokyonight";
  displayName = "Tokyo Night Moon";

  stylix = {
    image = ./wallpapers/tokyonight-0.png;
    base16Scheme = ./base16.yaml;
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  hyprland = {
    borderSize = 1;
    rounding = 0;
  };

  noctalia.radius = {
    container = 1.0;
    input = 1.0;
  };

  apps.neovim = {
    name = "tokyonight";
    style = "moon";
  };
}

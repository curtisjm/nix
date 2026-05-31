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
    gapsIn = 4;
    gapsOut = 8;
    borderSize = 2;
    rounding = 0;
    activeOpacity = 0.88;
    inactiveOpacity = 0.8;

    blur = {
      size = 12;
      passes = 3;
      noise = 0.04;
      contrast = 0.9;
      brightness = 0.85;
      vibrancy = 0.12;
      vibrancyDarkness = 0.35;
    };
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

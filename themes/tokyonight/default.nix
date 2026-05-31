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
    gapsIn = 3;
    gapsOut = 6;
    borderSize = 1;
    rounding = 0;
    activeOpacity = 0.9;
    inactiveOpacity = 0.82;

    blur = {
      size = 6;
      passes = 2;
      noise = 0.02;
      vibrancy = 0.08;
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

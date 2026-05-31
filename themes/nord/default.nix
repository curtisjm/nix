{ pkgs, mkTheme }:
mkTheme {
  name = "nord";
  displayName = "Nord";

  stylix = {
    image = ./wallpapers/nord-2.png;
    base16Scheme = ./base16.yaml;
    cursor = {
      name = "Nordzy";
      package = pkgs.nordzy-cursor-theme;
      size = 32;
    };
  };

  apps.neovim = {
    name = "nord";
    style = null;
  };
}

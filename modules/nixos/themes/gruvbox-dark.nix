{ pkgs, mkTheme }:
mkTheme {
  name = "gruvbox";
  displayName = "Gruvbox Dark";

  stylix = {
    image = ../../../wallpapers/gruv-cloud-valley.png;
    base16Scheme = ../../../themes/gruvbox-dark-custom.yaml;
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  apps.neovim = {
    name = "gruvbox";
    style = "dark";
  };
}

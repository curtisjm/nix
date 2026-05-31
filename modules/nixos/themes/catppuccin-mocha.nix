{ pkgs, mkTheme }:
mkTheme {
  name = "catppuccin-mocha";
  displayName = "Catppuccin Mocha";

  stylix = {
    image = ../../../wallpapers/dark-nix.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  apps.neovim = {
    name = "catppuccin";
    style = "mocha";
  };
}

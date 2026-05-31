{ pkgs, mkTheme }:
mkTheme {
  name = "ayu";
  displayName = "Ayu Dark";

  stylix = {
    image = ../../../wallpapers/ayu-5.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };
  };

  apps.neovim = {
    name = "tokyonight";
    style = "moon";
  };
}

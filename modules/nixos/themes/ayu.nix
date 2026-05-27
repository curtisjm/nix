{ pkgs, mkTheme }:
mkTheme {
  name = "ayu";
  displayName = "Ayu Dark";

  colors = {
    bg = "#0f1419";
    bgAlt = "#131721";
    fg = "#e6e1cf";
    fgAlt = "#b3b1ad";
    accent = "#39bae6";
    urgent = "#f07178";
    warning = "#ffb454";
    success = "#aad94c";
    info = "#59c2ff";
    border = "#2d3640";
  };

  stylix = {
    image = ../../../wallpapers/ayu-5.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };
  };

  hyprland = {
    activeBorder = "rgb(39bae6)";
    inactiveBorder = "rgba(2d3640aa)";
  };

  apps.neovim = {
    name = "tokyonight";
    style = "moon";
  };
}

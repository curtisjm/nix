{ pkgs, mkTheme }:
mkTheme {
  name = "nord";
  displayName = "Nord";

  colors = {
    bg = "#2e3440";
    bgAlt = "#3b4252";
    fg = "#eceff4";
    fgAlt = "#d8dee9";
    accent = "#88c0d0";
    urgent = "#bf616a";
    warning = "#ebcb8b";
    success = "#a3be8c";
    info = "#81a1c1";
    red = "#bf616a";
    orange = "#d08770";
    yellow = "#ebcb8b";
    green = "#a3be8c";
    cyan = "#88c0d0";
    blue = "#81a1c1";
    purple = "#b48ead";
    border = "#4c566a";
  };

  stylix = {
    image = ../../../wallpapers/nord-2.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    cursor = {
      name = "Nordzy";
      package = pkgs.nordzy-cursor-theme;
      size = 32;
    };
  };

  hyprland = {
    activeBorder = "rgb(88c0d0)";
    inactiveBorder = "rgba(4c566aaa)";
  };

  apps.neovim = {
    name = "nord";
    style = null;
  };
}

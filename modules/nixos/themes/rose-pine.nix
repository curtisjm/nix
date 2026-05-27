{ pkgs, mkTheme }:
mkTheme {
  name = "rose-pine";
  displayName = "Rose Pine";

  colors = {
    bg = "#191724";
    bgAlt = "#1f1d2e";
    fg = "#e0def4";
    fgAlt = "#908caa";
    accent = "#c4a7e7";
    urgent = "#eb6f92";
    warning = "#f6c177";
    success = "#31748f";
    info = "#9ccfd8";
    border = "#403d52";
  };

  stylix = {
    image = ../../../wallpapers/rose-pine-2.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    cursor = {
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };
  };

  hyprland = {
    activeBorder = "rgb(c4a7e7)";
    inactiveBorder = "rgba(403d52aa)";
  };

  apps.neovim = {
    name = "tokyonight";
    style = "moon";
  };
}

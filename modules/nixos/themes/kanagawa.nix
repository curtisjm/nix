{ pkgs, mkTheme }:
mkTheme {
  name = "kanagawa";
  displayName = "Kanagawa";

  colors = {
    bg = "#1f1f28";
    bgAlt = "#2a2a37";
    fg = "#dcd7ba";
    fgAlt = "#c8c093";
    accent = "#7e9cd8";
    urgent = "#c34043";
    warning = "#c0a36e";
    success = "#76946a";
    info = "#6a9589";
    border = "#54546d";
  };

  stylix = {
    image = ../../../wallpapers/kanagawa-1.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  hyprland = {
    activeBorder = "rgb(7e9cd8)";
    inactiveBorder = "rgba(54546daa)";
  };

  apps.neovim = {
    name = "tokyonight";
    style = "moon";
  };
}

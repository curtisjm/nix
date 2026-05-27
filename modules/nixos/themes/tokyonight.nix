{ pkgs, mkTheme }:
mkTheme {
  name = "tokyonight";
  displayName = "Tokyo Night Moon";

  colors = {
    bg = "#222436";
    bgAlt = "#2f334d";
    fg = "#c8d3f5";
    fgAlt = "#828bb8";
    accent = "#82aaff";
    urgent = "#ff757f";
    warning = "#ffc777";
    success = "#c3e88d";
    info = "#86e1fc";
    border = "#444a73";
  };

  stylix = {
    image = ../../../wallpapers/tokyonight-2.png;
    base16Scheme = ../../../themes/tokyo-night-moon-bright.yaml;
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  hyprland = {
    activeBorder = "rgb(82aaff)";
    inactiveBorder = "rgba(444a73aa)";
  };

  apps.neovim = {
    name = "tokyonight";
    style = "moon";
  };
}

{ pkgs, mkTheme }:
mkTheme {
  name = "gruvbox";
  displayName = "Gruvbox Dark";

  colors = {
    bg = "#282828";
    bgAlt = "#3c3836";
    fg = "#ebdbb2";
    fgAlt = "#d5c4a1";
    accent = "#83a598";
    urgent = "#fb4934";
    warning = "#fabd2f";
    success = "#b8bb26";
    info = "#8ec07c";
    red = "#fb4934";
    orange = "#fe8019";
    yellow = "#fabd2f";
    green = "#b8bb26";
    cyan = "#8ec07c";
    blue = "#83a598";
    purple = "#d3869b";
    border = "#665c54";
  };

  stylix = {
    image = ../../../wallpapers/gruv-cloud-valley.png;
    base16Scheme = ../../../themes/gruvbox-dark-custom.yaml;
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  # hyprland = {
  #   activeBorder = "rgb(83a598)";
  #   inactiveBorder = "rgba(665c54aa)";
  # };

  apps.neovim = {
    name = "gruvbox";
    style = "dark";
  };
}

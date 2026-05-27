{ pkgs, mkTheme }:
mkTheme {
  name = "catppuccin-mocha";
  displayName = "Catppuccin Mocha";

  colors = {
    bg = "#1e1e2e";
    bgAlt = "#313244";
    fg = "#cdd6f4";
    fgAlt = "#bac2de";
    accent = "#89b4fa";
    urgent = "#f38ba8";
    warning = "#f9e2af";
    success = "#a6e3a1";
    info = "#94e2d5";
    red = "#f38ba8";
    orange = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    cyan = "#94e2d5";
    blue = "#89b4fa";
    purple = "#cba6f7";
    border = "#45475a";
  };

  stylix = {
    image = ../../../wallpapers/dark-nix.png;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  hyprland = {
    activeBorder = "rgb(89b4fa)";
    inactiveBorder = "rgba(45475aaa)";
  };

  apps.neovim = {
    name = "catppuccin";
    style = "mocha";
  };
}

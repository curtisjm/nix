{ pkgs, mkTheme }:
mkTheme {
  name = "rose-pine";
  displayName = "Rose Pine";

  stylix = {
    image = ./wallpapers/rose-pine-2.jpg;
    base16Scheme = ./base16.yaml;
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

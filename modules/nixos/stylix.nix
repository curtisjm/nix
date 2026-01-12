{ pkgs, ... }:
{
    stylix.enable = true;
    stylix.image = ../../wallpapers/gruvbox-1.jpg;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
}

{
  hostConfig,
  pkgs,
  ...
}:
let
  terminalTheme = hostConfig.terminalTheme or { };
in
{
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${terminalTheme.base16Scheme or "tokyo-night-moon"}.yaml";
  stylix.polarity = terminalTheme.polarity or "dark";
}

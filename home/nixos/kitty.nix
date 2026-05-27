{ lib, osConfig, ... }:
let
  theme = osConfig.custom.theme.current or {};
  terminalTheme = theme.terminal or {};
in
{
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      font_size = terminalTheme.fontSize or 11;
    window_padding_width = lib.mkForce 0;
    window_margin_width = lib.mkForce 0;
    placement_strategy = "top-left";
    };
    extraConfig = theme.apps.kitty.extraConfig or "";
  };
}

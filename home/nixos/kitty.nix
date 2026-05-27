{ osConfig, ... }:
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
      window_padding_width = terminalTheme.padding or 14;
    };
    extraConfig = theme.apps.kitty.extraConfig or "";
  };
}

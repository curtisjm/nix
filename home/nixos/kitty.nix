{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
in
{
  programs.kitty = {
    enable = true;

    # Font configuration
    font = {
      name = theme.font.mono;
      size = theme.font.size.normal;
    };

    settings = {
      # Bell
      enable_audio_bell = false;

      # Window layout
      window_padding_width = 10;
      confirm_os_window_close = 0;

      # Cursor
      cursor_trail = 1;
      cursor_shape = "block";
      cursor_blink_interval = 0;

      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

      # Performance tuning
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # Colors - Basic
      foreground = theme.fg;
      background = theme.bg;
      selection_foreground = theme.bg;
      selection_background = theme.accent;

      # Cursor colors
      cursor = theme.accent;
      cursor_text_color = theme.bg;

      # URL color
      url_color = theme.blue;

      # Border colors
      active_border_color = theme.accent;
      inactive_border_color = theme.border;
      bell_border_color = theme.urgent;

      # Tab bar colors
      active_tab_foreground = theme.bg;
      active_tab_background = theme.accent;
      inactive_tab_foreground = theme.fg;
      inactive_tab_background = theme.bg-alt;
      tab_bar_background = theme.bg;

      # Terminal colors
      # Black
      color0 = theme.bg-alt;
      color8 = theme.fg-alt;

      # Red
      color1 = theme.red;
      color9 = theme.red;

      # Green
      color2 = theme.green;
      color10 = theme.green;

      # Yellow
      color3 = theme.yellow;
      color11 = theme.yellow;

      # Blue
      color4 = theme.blue;
      color12 = theme.blue;

      # Magenta
      color5 = theme.purple;
      color13 = theme.purple;

      # Cyan
      color6 = theme.cyan;
      color14 = theme.cyan;

      # White
      color7 = theme.fg;
      color15 = theme.fg;
    };

    # Keybindings
    keybindings = {
      # Open new tab in same directory
      "ctrl+shift+t" = "new_tab_with_cwd";
    };
  };
}

{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
  # Convert hex to RGB
  hexToRgb = hex: let
    r = builtins.substring 1 2 hex;
    g = builtins.substring 3 2 hex;
    b = builtins.substring 5 2 hex;
  in "${r}${g}${b}";
in
{
  # Swaylock - screen locker for Wayland
  # Colors from custom theme

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      # Styling
      font = theme.font.mono;
      font-size = 14;

      # Colors
      color = hexToRgb theme.bg;

      inside-color = hexToRgb theme.bg;
      line-color = hexToRgb theme.accent;
      ring-color = hexToRgb theme.accent;
      text-color = hexToRgb theme.fg;

      inside-clear-color = hexToRgb theme.info;
      line-clear-color = hexToRgb theme.info;
      ring-clear-color = hexToRgb theme.info;
      text-clear-color = hexToRgb theme.bg;

      inside-ver-color = hexToRgb theme.blue;
      line-ver-color = hexToRgb theme.blue;
      ring-ver-color = hexToRgb theme.blue;
      text-ver-color = hexToRgb theme.bg;

      inside-wrong-color = hexToRgb theme.urgent;
      line-wrong-color = hexToRgb theme.urgent;
      ring-wrong-color = hexToRgb theme.urgent;
      text-wrong-color = hexToRgb theme.bg;

      # Effects
      screenshots = true;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      clock = true;
      datestr = "%a, %B %d";
      timestr = "%H:%M:%S";
      fade-in = 0.2;

      # Behavior
      ignore-empty-password = true;
      show-failed-attempts = true;
      indicator-radius = 100;
      indicator-thickness = 7;

      grace = 2;
      grace-no-mouse = true;
      grace-no-touch = true;
    };
  };

  # Swayidle for automatic locking
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg \"output * power off\"";
        resumeCommand = "${pkgs.sway}/bin/swaymsg \"output * power on\"";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock -f";
      }
    ];
  };
}

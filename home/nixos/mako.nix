{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
in
{
  # Mako notification daemon with custom theming

  services.mako = {
    enable = true;

    # Settings (new format)
    settings = {
      # Appearance
      font = "${theme.font.mono} ${theme.font.size.normal}";
      width = 350;
      height = 150;
      margin = "10";
      padding = "15";
      border-size = 2;
      border-radius = 0;

      background-color = theme.bg;
      text-color = theme.fg;
      border-color = theme.accent;

      # Icons
      icons = 1;
      max-icon-size = 48;

      # Behavior
      layer = "overlay";
      anchor = "top-right";
      default-timeout = 5000;
      ignore-timeout = 0;

      # Grouping
      group-by = "app-name";
      max-visible = 5;
    };

    # Custom actions
    extraConfig = ''
      [urgency=low]
      border-color=${theme.info}
      default-timeout=3000

      [urgency=high]
      border-color=${theme.urgent}
      default-timeout=0
      border-size=3
    '';
  };
}

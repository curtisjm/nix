{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
in
{
  # Mako notification daemon with custom theming

  services.mako = {
    enable = true;

    # Appearance
    font = "${theme.font.mono} ${theme.font.size.normal}";
    width = 350;
    height = 150;
    margin = "10";
    padding = "15";
    borderSize = 2;
    borderRadius = 0;

    backgroundColor = theme.bg;
    textColor = theme.fg;
    borderColor = theme.accent;

    # Icons
    icons = true;
    maxIconSize = 48;

    # Behavior
    layer = "overlay";
    anchor = "top-right";
    defaultTimeout = 5000;
    ignoreTimeout = false;

    # Grouping
    groupBy = "app-name";
    maxVisible = 5;

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

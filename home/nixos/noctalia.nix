{
  pkgs,
  inputs,
  lib,
  osConfig,
  hostConfig,
  ...
}:
let
  get =
    attrs: name: default:
    if builtins.hasAttr name attrs then attrs.${name} else default;

  transparency = osConfig.custom.theme.transparency or false;
  theme = osConfig.custom.theme.current or { };
  noctaliaTheme = theme.noctalia or { };
  wallpaper = "${theme.stylix.image}";

  defaultOpacity = if transparency then 0.75 else 1.0;
  opacity = get noctaliaTheme "opacity" defaultOpacity;
  sectionOpacity = name: lib.mkForce (get (noctaliaTheme.opacityBySection or { }) name opacity);

  shellRadiusScale = lib.mkForce (get noctaliaTheme "cornerRadiusScale" 1.35);
  barRadius = lib.mkForce (get noctaliaTheme "barRadius" 80);
  capsuleRadius = lib.mkForce (get noctaliaTheme "capsuleRadius" 80);

  animations = noctaliaTheme.animations or { };

  barEndWidgets = [
    "tray"
  ]
  ++ lib.optionals hostConfig.isLaptop [
    "battery"
  ]
  ++ [
    "volume"
  ]
  ++ lib.optionals hostConfig.isLaptop [
    "brightness"
  ]
  ++ [
    "sysmon"
  ];
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    settings = lib.recursiveUpdate {
      shell = {
        font_family = "Inter";
        corner_radius_scale = shellRadiusScale;
        input_borders = true;
        setup_wizard_enabled = false;
        telemetry_enabled = false;
        panel = {
          control_center_placement = "attached";
          control_center_position = "auto";
          wallpaper_placement = "attached";
          wallpaper_position = "auto";
          session_placement = "attached";
          session_position = "auto";
        };
        launcher = {
          categories = true;
          show_icons = true;
          sort_by_usage = true;
          providers.clipboard.global = true;
        };
        clipboard_enabled = true;
      }
      // lib.optionalAttrs (builtins.hasAttr "speed" animations) {
        animation.speed = lib.mkForce animations.speed;
      }
      // lib.optionalAttrs (builtins.hasAttr "disabled" animations) {
        animation.enabled = lib.mkForce (!animations.disabled);
      };

      bar = {
        order = [ "default" ];
        default = {
          enabled = true;
          position = "right";
          background_opacity = sectionOpacity "bar";
          reserve_space = true;
          layer = "top";
          margin_ends = 4;
          margin_edge = 4;
          padding = 8;
          scale = lib.mkForce (get noctaliaTheme "scaleRatio" 0.85);
          radius = barRadius;
          radius_top_left = barRadius;
          radius_top_right = barRadius;
          radius_bottom_left = barRadius;
          radius_bottom_right = barRadius;
          concave_edge_corners = false;
          capsule = true;
          capsule_opacity = 1.0;
          capsule_radius = capsuleRadius;
          start = [
            "control-center"
            "clock"
            "notifications"
            "launcher"
            "media"
          ];
          center = [
            "workspaces"
          ];
          end = barEndWidgets;
        };
      };

      widget = {
        control-center.type = "control-center";
        clock.type = "clock";
        notifications.type = "notifications";
        launcher.type = "launcher";
        media.type = "media";
        workspaces.type = "workspaces";
        tray.type = "tray";
        battery.type = "battery";
        volume.type = "volume";
        brightness.type = "brightness";
        sysmon.type = "sysmon";
      };

      control_center = {
        sidebar = "compact";
        sidebar_section = "compact";
        show_session_button = true;
      };

      location = {
        city = "San Francisco";
        use_fahrenheit = true;
      };

      weather = {
        enabled = true;
      };

      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        transition_on_startup = false;
        automation.enabled = false;
        default.path = wallpaper;
        last.path = wallpaper;
      };
      dock = {
        enabled = false;
        background_opacity = sectionOpacity "dock";
      };

      notification = {
        background_opacity = sectionOpacity "notifications";
        position = "top_right";
      };

      osd = {
        background_opacity = sectionOpacity "osd";
        position = "top_right";
        position_vertical = "top_right";
      };

      theme = {
        source = "custom";
        custom_palette = "stylix";
        mode = "dark";
      };
    } (noctaliaTheme.settings or { });
  };
}

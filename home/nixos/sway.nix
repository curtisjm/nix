{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
in
{
  # Sway configuration managed by home-manager
  # Colors from custom theme module
  # Custom keybindings and behavior defined here

  wayland.windowManager.sway = {
    enable = true;

    config = rec {
      # Use Alt as modifier (like your current config)
      modifier = "Mod1";

      # Terminal
      terminal = "kitty";

      # Application launcher - rofi
      menu = "rofi -show drun";

      # Vim-style navigation keys
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      # Keybindings
      keybindings = let
        mod = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        # Applications
        "${mod}+Return" = "exec ${config.wayland.windowManager.sway.config.terminal}";
        "${mod}+space" = "exec ${config.wayland.windowManager.sway.config.menu}";
        "${mod}+Shift+q" = "kill";

        # Browser (extra workspace bindings from your config)
        "${mod}+t" = "workspace number 11";
        "${mod}+b" = "workspace number 12";
        "${mod}+o" = "workspace number 13";
        "${mod}+Shift+t" = "move container to workspace number 11";
        "${mod}+Shift+b" = "move container to workspace number 12";
        "${mod}+Shift+o" = "move container to workspace number 13";

        # Screenshots
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "Shift+Print" = "exec grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png";

        # Clipboard
        "${mod}+v" = "exec cliphist list | rofi -dmenu | cliphist decode | wl-copy";
      };

      # Startup applications
      startup = [
        # Clipboard manager
        { command = "wl-paste --type text --watch cliphist store"; }
        { command = "wl-paste --type image --watch cliphist store"; }

        # Network manager applet
        { command = "nm-applet --indicator"; }
      ];

      # Input configuration (from your current config)
      input = {
        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };

      # Output configuration
      output = {
        "*" = {
          bg = "${theme.wallpaper} fill";
        };
      };

      # Colors
      colors = {
        focused = {
          background = theme.accent;
          border = theme.accent;
          childBorder = theme.accent;
          indicator = theme.accent;
          text = theme.bg;
        };
        focusedInactive = {
          background = theme.bg-alt;
          border = theme.border;
          childBorder = theme.border;
          indicator = theme.bg-alt;
          text = theme.fg;
        };
        unfocused = {
          background = theme.bg;
          border = theme.border;
          childBorder = theme.border;
          indicator = theme.bg;
          text = theme.fg-alt;
        };
        urgent = {
          background = theme.urgent;
          border = theme.urgent;
          childBorder = theme.urgent;
          indicator = theme.urgent;
          text = theme.bg;
        };
      };

      # Window appearance
      window = {
        border = 2;
        titlebar = false;
      };

      floating = {
        border = 2;
        titlebar = false;
      };

      gaps = {
        inner = 8;
        outer = 4;
      };

      # Focus follows mouse
      focus.followMouse = true;

      # Bars - we disable the default since waybar is configured separately
      bars = [ ];
    };

    # Extra config that doesn't fit in the structured options
    extraConfig = ''
      # Floating windows
      for_window [app_id="pavucontrol"] floating enable
      for_window [app_id="nm-connection-editor"] floating enable

      # Disable focus wrapping
      focus_wrapping no
    '';
  };

  # Install required packages for sway session
  home.packages = with pkgs; [
    wl-clipboard     # Clipboard utilities
    grim             # Screenshot tool
    slurp            # Screen region selector
    cliphist         # Clipboard manager
    networkmanagerapplet  # Network manager tray
  ];
}

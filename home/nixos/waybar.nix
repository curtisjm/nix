{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
in
{
  # Waybar configuration with custom modules and styling
  # Colors from custom theme module

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";  # Keep your bottom bar preference
        height = 32;
        spacing = 4;

        # Left modules - workspaces and mode
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];

        # Center modules - window title
        modules-center = [
          "sway/window"
        ];

        # Right modules - system info (HyDE-inspired)
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "clock"
          "tray"
        ];

        # Module configurations
        "sway/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            "11" = "";  # Browser workspace
            "12" = "";  # Terminal workspace
            "13" = "";  # Other workspace
            urgent = "";
            focused = "";
            default = "";
          };
        };

        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "sway/window" = {
          max-length = 50;
          separate-outputs = true;
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          format = "{:%a %d %b  %H:%M:%S}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          interval = 1;
        };

        "cpu" = {
          format = " {usage}%";
          tooltip = false;
          interval = 2;
          on-click = "kitty -e btop";
        };

        "memory" = {
          format = " {percentage}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
          interval = 2;
          on-click = "kitty -e btop";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = ["" "" "" "" ""];
          tooltip-format = "{timeTo}, {capacity}%";
        };

        "network" = {
          format-wifi = " {signalStrength}%";
          format-ethernet = " {ipaddr}";
          format-disconnected = "󰤮 Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\n {bandwidthUpBytes}  {bandwidthDownBytes}";
          on-click = "nm-connection-editor";
          interval = 5;
        };

        "pulseaudio" = {
          scroll-step = 5;
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = " Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
          tooltip-format = "{desc}, {volume}%";
        };
      };
    };

    # Custom CSS styling with theme colors
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "${theme.font.mono}";
        font-size: ${theme.font.size.normal}pt;
        min-height: 0;
      }

      window#waybar {
        background-color: ${theme.bg};
        color: ${theme.fg};
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      /* Workspaces */
      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: ${theme.fg};
        border-bottom: 2px solid transparent;
      }

      #workspaces button:hover {
        background-color: ${theme.bg-alt};
        border-bottom: 2px solid ${theme.accent};
      }

      #workspaces button.focused {
        background-color: ${theme.accent};
        color: ${theme.bg};
        border-bottom: 2px solid ${theme.accent};
      }

      #workspaces button.urgent {
        background-color: ${theme.urgent};
        color: ${theme.bg};
      }

      /* All modules styling */
      #clock,
      #battery,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #tray,
      #mode,
      #window {
        padding: 4px 10px;
        margin: 2px 2px;
        background-color: ${theme.bg-alt};
        color: ${theme.fg};
      }

      /* Individual module colors for visual distinction */
      #cpu {
        color: ${theme.blue};
      }

      #memory {
        color: ${theme.purple};
      }

      #battery {
        color: ${theme.green};
      }

      #battery.charging {
        color: ${theme.green};
      }

      #battery.warning:not(.charging) {
        color: ${theme.warning};
      }

      #battery.critical:not(.charging) {
        color: ${theme.urgent};
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          background-color: ${theme.urgent};
          color: ${theme.bg};
        }
      }

      #network {
        color: ${theme.cyan};
      }

      #network.disconnected {
        color: ${theme.urgent};
      }

      #pulseaudio {
        color: ${theme.yellow};
      }

      #pulseaudio.muted {
        color: ${theme.fg-alt};
      }

      #clock {
        color: ${theme.fg};
        font-weight: bold;
      }

      #mode {
        background-color: ${theme.urgent};
        color: ${theme.bg};
        font-weight: bold;
      }

      #window {
        background-color: transparent;
        color: ${theme.fg};
        font-style: italic;
      }

      #tray {
        background-color: ${theme.bg-alt};
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: ${theme.urgent};
      }
    '';
  };

  # Additional packages needed for waybar modules
  home.packages = with pkgs; [
    pavucontrol  # Volume control GUI
    btop         # System monitor
  ];
}

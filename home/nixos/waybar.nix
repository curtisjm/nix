{ ... }:
{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 26;
        spacing = 0;

        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "network" "pulseaudio" "cpu" "battery" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "sway/mode" = {
          format = "{}";
        };

        clock = {
          format = "{:%a %H:%M}";
          format-alt = "{:%d %B %Y}";
          tooltip = false;
        };

        cpu = {
          interval = 5;
          format = "󰍛 {usage}%";
          tooltip = false;
        };

        battery = {
          interval = 5;
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = " {capacity}%";
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          states = {
            warning = 20;
            critical = 10;
          };
          tooltip = false;
        };

        network = {
          interval = 3;
          format-wifi = "󰤨 {essid}";
          format-ethernet = "󰀂";
          format-disconnected = "󰤮";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n⇣{bandwidthDownBytes} ⇡{bandwidthUpBytes}";
          tooltip-format-ethernet = "⇣{bandwidthDownBytes} ⇡{bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = {
            headphone = "󰋋";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          scroll-step = 5;
          tooltip = false;
        };

        tray = {
          icon-size = 14;
          spacing = 8;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: alpha(@base00, 0.9);
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        padding: 0 6px;
        margin: 0 2px;
        color: @base05;
      }

      #workspaces button.focused {
        color: @base0D;
      }

      #workspaces button.urgent {
        color: @base08;
      }

      #clock,
      #cpu,
      #battery,
      #network,
      #pulseaudio,
      #tray,
      #mode {
        padding: 0 8px;
      }

      #battery.warning {
        color: @base0A;
      }

      #battery.critical {
        color: @base08;
      }

      #mode {
        color: @base08;
      }
    '';
  };
}

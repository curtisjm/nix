{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
in
{
  # Rofi configuration with custom theming
  # Using custom colors with HyDE-inspired layout

  programs.rofi = {
    enable = true;
    package = pkgs.rofi;

    font = "${theme.font.mono} 12";

    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Window";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
    };
  };

  # Rofi theme file
  home.file.".config/rofi/theme.rasi".text = ''
    * {
      bg: ${theme.bg};
      bg-alt: ${theme.bg-alt};
      fg: ${theme.fg};
      fg-alt: ${theme.fg-alt};
      accent: ${theme.accent};
      urgent: ${theme.urgent};

      background-color: transparent;
      text-color: @fg;
    }

    window {
      transparency: "real";
      background-color: @bg;
      border: 2px;
      border-color: @accent;
      border-radius: 0px;
      width: 600px;
      padding: 0px;
    }

    mainbox {
      background-color: transparent;
      children: [inputbar, listview];
      spacing: 10px;
      padding: 10px;
    }

    inputbar {
      background-color: @bg-alt;
      text-color: @fg;
      border: 0px 0px 2px 0px;
      border-color: @accent;
      padding: 10px;
      children: [prompt, entry];
    }

    prompt {
      background-color: transparent;
      text-color: @accent;
      padding: 0px 10px 0px 0px;
    }

    entry {
      background-color: transparent;
      text-color: @fg;
      placeholder-color: @fg-alt;
      placeholder: "Search...";
    }

    listview {
      background-color: transparent;
      columns: 1;
      lines: 10;
      spacing: 5px;
      cycle: true;
      dynamic: true;
      layout: vertical;
    }

    element {
      background-color: transparent;
      text-color: @fg;
      padding: 8px;
      border-radius: 0px;
    }

    element normal.normal {
      background-color: transparent;
      text-color: @fg;
    }

    element selected.normal {
      background-color: @accent;
      text-color: @bg;
    }

    element normal.active {
      background-color: transparent;
      text-color: ${theme.success};
    }

    element selected.active {
      background-color: ${theme.success};
      text-color: @bg;
    }

    element normal.urgent {
      background-color: transparent;
      text-color: @urgent;
    }

    element selected.urgent {
      background-color: @urgent;
      text-color: @bg;
    }

    element-text {
      background-color: transparent;
      text-color: inherit;
    }

    element-icon {
      background-color: transparent;
      size: 24px;
      padding: 0px 10px 0px 0px;
    }
  '';

  # Power menu script
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "rofi-power-menu" ''
      #!/usr/bin/env bash

      option1=" Lock"
      option2=" Logout"
      option3=" Suspend"
      option4=" Reboot"
      option5=" Shutdown"

      chosen=$(echo -e "$option1\n$option2\n$option3\n$option4\n$option5" | \
        rofi -dmenu -p "Power" -theme ~/.config/rofi/theme.rasi -theme-str 'window {width: 300px;}')

      case $chosen in
        "$option1") swaylock ;;
        "$option2") swaymsg exit ;;
        "$option3") systemctl suspend ;;
        "$option4") systemctl reboot ;;
        "$option5") systemctl poweroff ;;
      esac
    '')
  ];
}

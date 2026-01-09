{ config, pkgs, lib, osConfig, ... }:

let
  theme = osConfig.theme;
in
{
  # Wlogout - A wayland-based logout menu
  # Provides graphical power menu with lock, logout, suspend, reboot, shutdown options

  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "swaylock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "swaymsg exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "swaylock & systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];

    style = ''
      * {
        background-image: none;
        box-shadow: none;
        font-family: "${theme.font.sans}";
        font-size: ${theme.font.size.normal}pt;
      }

      window {
        background-color: rgba(0, 0, 0, 0.8);
      }

      button {
        color: ${theme.fg};
        background-color: ${theme.bg};
        border: 2px solid ${theme.bg-alt};
        border-radius: 8px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        margin: 5px;
        transition: all 0.3s ease;
      }

      button:focus,
      button:active {
        background-color: ${theme.bg-alt};
        outline-style: none;
      }

      button:hover {
        background-color: ${theme.bg-alt};
        background-size: 30%;
        border: 2px solid ${theme.accent};
      }

      /* Lock button */
      #lock {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
      }

      #lock:hover {
        border-color: ${theme.yellow};
      }

      /* Logout button */
      #logout {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
      }

      #logout:hover {
        border-color: ${theme.blue};
      }

      /* Suspend button */
      #suspend {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
      }

      #suspend:hover {
        border-color: ${theme.cyan};
      }

      /* Shutdown button */
      #shutdown {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
      }

      #shutdown:hover {
        border-color: ${theme.urgent};
      }

      /* Reboot button */
      #reboot {
        background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
      }

      #reboot:hover {
        border-color: ${theme.orange};
      }
    '';
  };

  # Add wlogout package
  home.packages = with pkgs; [
    wlogout
  ];
}

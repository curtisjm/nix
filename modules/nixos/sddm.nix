{ config, pkgs, lib, ... }:

{
  # SDDM - Display/Login Manager
  # Provides graphical login screen for Sway

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;  # Use Wayland for SDDM itself

    # Theme configuration
    theme = "breeze";  # Default theme, can be customized

    settings = {
      General = {
        # Use system theme colors
        DisplayServer = "wayland";
        GreeterEnvironment = "QT_SCREEN_SCALE_FACTORS=1,QT_FONT_DPI=96";
      };

      Theme = {
        Current = "breeze";
        CursorTheme = "Bibata-Modern-Classic";
      };

      Users = {
        # Minimum UID shown in user list (hides system users)
        MinimumUid = 1000;
        MaximumUid = 65000;
        HideUsers = "";
        HideShells = "/bin/false,/usr/bin/nologin";
      };
    };
  };

  # Ensure Sway is available as a session
  services.displayManager.sessionPackages = [ pkgs.sway ];
}

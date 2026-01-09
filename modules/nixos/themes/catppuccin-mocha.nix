{
  name = "Catppuccin Mocha";

  # Main colors
  bg = "#1e1e2e";        # Base
  bg-alt = "#313244";    # Surface0
  fg = "#cdd6f4";        # Text
  fg-alt = "#bac2de";    # Subtext1

  # Accent colors
  accent = "#89b4fa";    # Blue
  urgent = "#f38ba8";    # Red
  warning = "#f9e2af";   # Yellow
  success = "#a6e3a1";   # Green
  info = "#94e2d5";      # Teal

  # Additional colors
  red = "#f38ba8";
  orange = "#fab387";
  yellow = "#f9e2af";
  green = "#a6e3a1";
  cyan = "#94e2d5";
  blue = "#89b4fa";
  purple = "#cba6f7";

  # UI elements
  border = "#45475a";

  # Fonts
  font = {
    mono = "JetBrainsMono Nerd Font Mono";
    sans = "JetBrainsMono Nerd Font";
    size = {
      small = "10";
      normal = "11";
      large = "12";
    };
  };

  # Wallpaper (use absolute path for Nix build sandbox)
  wallpaper = "/home/curtis/nix/wallpapers/dark-nix.png";
}

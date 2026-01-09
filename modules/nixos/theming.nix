{ config, pkgs, lib, ... }:

{
  # Custom theming module - simple and effective
  # Change colorScheme to switch themes system-wide

  # Define available color schemes
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    description = "System-wide color scheme";
  };

  config = {
    # Current active theme - CHANGE THIS LINE TO SWITCH THEMES
    theme = import ./themes/gruvbox-dark.nix;

    # System fonts
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-emoji
    ];

    # Cursor theme
    environment.systemPackages = with pkgs; [
      bibata-cursors
    ];
  };
}

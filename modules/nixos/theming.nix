{
  config,
  pkgs,
  lib,
  ...
}:

{
  options.theme = lib.mkOption {
    type = lib.types.attrs;
    default = config.custom.theme.current;
    description = "System-wide color scheme";
  };

  config = {
    theme = config.custom.theme.current;

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-emoji
    ];

    environment.systemPackages = with pkgs; [
      bibata-cursors
    ];
  };
}

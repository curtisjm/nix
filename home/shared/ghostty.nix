{
  hostConfig,
  lib,
  ...
}:
let
  terminalTheme = hostConfig.terminalTheme or { };
  useStylix = terminalTheme.useStylixForGhostty or false;
in
{
  programs.ghostty = lib.mkIf useStylix {
    enable = true;
    package = null;
    settings = {
      font-family = lib.mkForce [ "JetBrains Mono" ];
      font-size = lib.mkForce 16;
      mouse-hide-while-typing = true;
      window-decoration = true;
      macos-option-as-alt = true;
      macos-titlebar-style = "hidden";
      background-opacity = 0.8;
      background-blur = "macos-glass-regular";
    };
  };

  # Preserve the existing shared default for hosts that do not opt into the
  # host-specific Stylix terminal theme.
  home.file = lib.mkIf (!useStylix) {
    ".config/ghostty/config".text = ''
      font-family = JetBrains Mono
      font-size = 16
      mouse-hide-while-typing = true
      window-decoration = true
      macos-option-as-alt = true
      macos-titlebar-style = hidden
      theme = TokyoNight Moon
    '';
  };
}

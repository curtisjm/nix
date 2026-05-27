{
  lib,
  pkgs,
}:
let
  mkTheme = overrides:
    let
      theme = lib.recursiveUpdate {
        stylix.fonts = {
          monospace = {
            package = pkgs.jetbrains-mono;
            name = "JetBrains Mono";
          };
          sansSerif = {
            package = pkgs.inter;
            name = "Inter";
          };
          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
          sizes = {
            terminal = 11;
            applications = 11;
            desktop = 11;
          };
        };

        hyprland = {
          gapsIn = 5;
          gapsOut = 10;
          borderSize = 2;
          rounding = 6;
          roundingPower = 3;
          activeOpacity = 0.82;
          inactiveOpacity = 0.75;
          fullscreenOpacity = 1.0;
          activeBorder = null;
          inactiveBorder = null;

          shadow = {
            enabled = true;
            range = 20;
            renderPower = 2;
            offset = "0 5";
            color = "rgba(00000055)";
          };

          blur = {
            enabled = true;
            size = 10;
            passes = 3;
            noise = 0.04;
            contrast = 1.0;
            brightness = 1.0;
            vibrancy = 0.15;
            vibrancyDarkness = 0.5;
            newOptimizations = true;
            popups = true;
          };
        };

        terminal = {
          fontSize = 11;
          padding = 14;
        };

        apps = {
          neovim = {
            name = "tokyonight";
            style = "moon";
          };
          kitty.extraConfig = "";
          obsidian.css = null;
        };
      } overrides;
    in
      theme
      // {
        bg = theme.colors.bg;
        bg-alt = theme.colors.bgAlt;
        fg = theme.colors.fg;
        fg-alt = theme.colors.fgAlt;
        accent = theme.colors.accent;
        urgent = theme.colors.urgent;
        warning = theme.colors.warning;
        success = theme.colors.success;
        info = theme.colors.info;
        red = theme.colors.red or theme.colors.urgent;
        orange = theme.colors.orange or theme.colors.warning;
        yellow = theme.colors.yellow or theme.colors.warning;
        green = theme.colors.green or theme.colors.success;
        cyan = theme.colors.cyan or theme.colors.info;
        blue = theme.colors.blue or theme.colors.accent;
        purple = theme.colors.purple or theme.colors.accent;
        border = theme.colors.border;

        font = {
          mono = "JetBrainsMono Nerd Font Mono";
          sans = "JetBrainsMono Nerd Font";
          size = {
            small = "10";
            normal = "11";
            large = "12";
          };
        };
      };
in
{
  nord = import ./nord.nix { inherit pkgs mkTheme; };
  gruvbox = import ./gruvbox-dark.nix { inherit pkgs mkTheme; };
  tokyonight = import ./tokyonight.nix { inherit pkgs mkTheme; };
  rose-pine = import ./rose-pine.nix { inherit pkgs mkTheme; };
  ayu = import ./ayu.nix { inherit pkgs mkTheme; };
  kanagawa = import ./kanagawa.nix { inherit pkgs mkTheme; };
  catppuccin-mocha = import ./catppuccin-mocha.nix { inherit pkgs mkTheme; };
}

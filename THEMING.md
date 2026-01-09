# NixOS Sway Desktop Theming Guide

This configuration uses a **hybrid approach** combining stylix (automatic theming) with custom configurations for desktop components.

## Architecture

### What Stylix Handles (Automatic)
- **GTK/Qt apps**: All GUI applications get consistent theming
- **Terminal colors**: Kitty, terminals automatically themed
- **CLI tools**: bat, vim, helix, etc.
- **Base colors**: Provides base16 color palette to all components
- **Fonts**: System-wide font configuration
- **Lock screen**: Swaylock colors
- **Notifications**: Mako notification colors

### What's Custom (Manual Control)
- **Sway**: Window manager keybindings, behavior, gaps
- **Waybar**: Module layout, specific styling, icons
- **Rofi**: Launcher layout, custom power menu
- **Component behavior**: All functional configs

## Switching Themes

Themes are defined in `/modules/nixos/theming.nix`.

### Quick Theme Switch

Edit line 16 in `modules/nixos/theming.nix`:

```nix
base16Scheme = "${pkgs.base16-schemes}/share/themes/THEME_NAME.yaml";
```

### Available Themes

Popular themes you can use:
- `gruvbox-dark-medium.yaml` (default - warm, earthy)
- `catppuccin-mocha.yaml` (pastel, purple-ish)
- `tokyo-night-dark.yaml` (blue, modern)
- `dracula.yaml` (purple, popular)
- `nord.yaml` (blue/grey, minimal)
- `onedark.yaml` (atom editor inspired)
- `solarized-dark.yaml` (classic)

All available themes are in: `/nix/store/.../share/themes/`

You can list them with:
```bash
ls $(nix-build --no-out-link '<nixpkgs>' -A base16-schemes)/share/themes/
```

### After Changing Theme

Rebuild your system:
```bash
sudo nixos-rebuild switch --flake .#laptop
```

## Component Details

### Sway (`home/nixos/sway.nix`)
- **Keybindings**: Alt-based (Mod1)
- **Features**: Auto-lock, clipboard, screenshots
- **Styling**: Colors from stylix, custom gaps/borders

### Waybar (`home/nixos/waybar.nix`)
- **Position**: Bottom bar
- **Modules**: Workspaces, window title, CPU, memory, battery, network, volume, clock
- **Icons**: Nerd Font icons for visual appeal
- **Colors**: Base colors from stylix, custom module colors

### Rofi (`home/nixos/rofi.nix`)
- **Modes**: Apps (drun), Run, Window switcher
- **Extra**: Power menu script (`rofi-power-menu`)
- **Styling**: Stylix colors with custom layout

### Mako (`home/nixos/mako.nix`)
- **Position**: Top-right
- **Behavior**: Auto-dismiss after 5s, grouping by app
- **Styling**: Fully automatic via stylix

### Swaylock (`home/nixos/swaylock.nix`)
- **Features**: Blur effect, clock, auto-lock after 5min
- **Styling**: Colors from stylix
- **Idle**: Screen off after 10min

## Customization Examples

### Change Wallpaper

Edit `modules/nixos/theming.nix`:
```nix
image = ../../wallpapers/your-wallpaper.png;
```

### Change Fonts

Edit `modules/nixos/theming.nix`:
```nix
fonts.monospace = {
  package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
  name = "FiraCode Nerd Font Mono";
};
```

### Adjust Waybar Position

Edit `home/nixos/waybar.nix`:
```nix
position = "top";  # or "bottom"
```

### Add Custom Rofi Modes

Edit keybinding in `home/nixos/sway.nix`:
```nix
"${mod}+p" = "exec rofi-power-menu";
```

### Change Opacity

Edit `modules/nixos/theming.nix`:
```nix
opacity = {
  terminal = 0.90;  # More opaque
  applications = 1.0;  # Fully opaque
};
```

## HyDE-Inspired Features Included

✓ Comprehensive theming system
✓ Multiple rofi modes (launcher + power menu)
✓ System info bar (waybar)
✓ Notification system (mako)
✓ Lock screen with effects (swaylock)
✓ Screenshot tools (grim + slurp)
✓ Clipboard manager (cliphist)
✓ Auto-lock and idle management
✓ GTK/Qt application theming
✓ Icon themes

## File Structure

```
modules/nixos/
├── theming.nix          # Main theme config (EDIT THIS TO CHANGE THEMES)
├── sway.nix             # Window manager config
├── packages.nix         # System packages
└── fonts.nix            # Font packages

home/nixos/
├── sway.nix             # Sway user config
├── waybar.nix           # Status bar config
├── rofi.nix             # Launcher config
├── mako.nix             # Notifications
├── swaylock.nix         # Lock screen
└── gtk.nix              # GTK theming
```

## Tips

1. **Testing themes**: Change the theme, rebuild, and see the results immediately
2. **Creating themes**: You can create custom base16 schemes in YAML
3. **Overriding colors**: Individual components can override stylix colors if needed
4. **Keeping it minimal**: This setup is lean - only essential components installed
5. **Adding features**: Easy to extend by adding new home-manager modules

## Troubleshooting

**Waybar not showing:**
```bash
systemctl --user restart waybar
```

**Lock screen colors wrong:**
```bash
systemctl --user restart swayidle
```

**Theme not applying:**
```bash
sudo nixos-rebuild switch --flake .#laptop
systemctl --user restart graphical-session.target
```

# HyDE Components Implementation Plan

This document tracks which HyDE components are implemented vs. still needed.

## ✅ Already Implemented

- [x] Sway window manager with custom colors
- [x] Waybar status bar (basic)
- [x] Rofi launcher with power menu
- [x] Mako notifications
- [x] Swaylock with effects
- [x] GTK/Qt dark theming
- [x] Custom color scheme system (3 themes)
- [x] Screenshot tools (grim + slurp)
- [x] Clipboard manager (cliphist)
- [x] Basic fonts (JetBrainsMono Nerd Font)

## 🚧 In Progress

- [ ] SDDM display manager (added, needs testing)

## 📋 High Priority - Missing Core Components

### Display & Login
- [ ] SDDM theming (custom themes)

### Terminal
- [ ] Kitty terminal with theme integration
- [ ] Zsh with Starship prompt (currently using basic zsh)

### Notifications & Menus
- [ ] SwayNC notification center (replace mako)
- [ ] Wlogout styled power menu (replace rofi power)

### Utilities
- [ ] Brightnessctl (screen brightness)
- [ ] Playerctl (media playback control)
- [ ] Hyprpicker or similar color picker
- [ ] Satty (screenshot annotation)
- [ ] Network manager applet UI

### Waybar Enhancements
- [ ] Media player module
- [ ] Weather module (wttrbar)
- [ ] Updates module
- [ ] Better tray integration
- [ ] Workspace icons/styling
- [ ] Animations

## 📋 Medium Priority - Enhanced Experience

### File Management
- [ ] Dolphin or Thunar file manager
- [ ] trash-cli integration

### System Info
- [ ] Fastfetch with custom preset

### Audio/Media
- [ ] Pavucontrol (GUI volume control) - already in packages
- [ ] Cava (audio visualizer)

### Input
- [ ] Libinput-gestures (touchpad gestures)

### Shell Enhancements
- [ ] Bat config with theme
- [ ] Eza config with icons
- [ ] Zoxide (already installed via shared)

## 📋 Low Priority - Optional Polish

### Gaming
- [ ] Gamemode daemon
- [ ] MangoHUD overlay
- [ ] Steam theming

### Development
- [ ] VS Code with theme
- [ ] Vim/Neovim theme integration

### Additional Themes
- [ ] More color schemes (Tokyo Night, Dracula, etc.)
- [ ] Wallpaper management system
- [ ] Dynamic wallpaper-based theming (wallbash equivalent)

## 🎨 Aesthetic Enhancements Needed

### Sway
- [ ] Window animations (limited in Sway)
- [ ] Better workspace styling
- [ ] Custom window rules

### Waybar
- [ ] Hover effects
- [ ] Transition animations
- [ ] Icon improvements
- [ ] Better module spacing/grouping

### Rofi
- [ ] Multiple launcher styles
- [ ] Wi-Fi menu
- [ ] Bluetooth menu
- [ ] Emoji/glyph picker

### Colors & Theming
- [ ] More granular color definitions
- [ ] Per-application color overrides
- [ ] Accent color variations

## 🔧 System Integration

### Services
- [ ] Polkit authentication agent
- [ ] XDG desktop portal configuration
- [ ] UDiskie (auto-mount USB)
- [ ] Bluez (Bluetooth)

### Session Management
- [ ] Proper environment variables
- [ ] Session startup scripts
- [ ] Auto-start applications

## Implementation Priority Order

1. **Critical (Do First)**
   - SDDM testing and theming
   - Kitty terminal configuration
   - Starship prompt
   - SwayNC notifications
   - Wlogout power menu

2. **High Priority (Do Next)**
   - Enhanced waybar modules
   - Color picker utility
   - Playerctl/media controls
   - File manager integration

3. **Medium Priority (Polish)**
   - Shell enhancements (bat, eza configs)
   - System tray improvements
   - Gestures support
   - Fastfetch

4. **Low Priority (Optional)**
   - Gaming tools
   - IDE theming
   - Additional themes
   - Wallpaper system

## Notes

- Focus on Wayland-native tools where possible
- Sway has fewer animation capabilities than Hyprland
- Some HyDE features (wallbash, theme patcher) need custom implementation
- Keep configuration minimal but complete

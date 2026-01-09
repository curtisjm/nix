# HyDE-Style Desktop Implementation Plan

This document outlines what will be added to make your NixOS Sway setup more like HyDE.

## What We're Adding

### 1. SDDM Display Manager ✓ (Created)
- **File**: `modules/nixos/sddm.nix`
- **Purpose**: Graphical login screen
- **What it does**: Replaces TTY login with nice GUI, manages sessions

### 2. Enhanced Kitty Terminal
- **File**: `home/nixos/kitty.nix` (will update)
- **What's new**:
  - Full theme color integration (all 16 terminal colors)
  - Tab bar with powerline style
  - Custom keybindings
  - Performance optimizations
  - Padding and visual polish

### 3. Starship Prompt
- **File**: `home/shared/starship.nix` (will update)
- **What it does**: Beautiful, fast shell prompt showing git status, directory, etc.
- **Why**: Much prettier than default PS1

### 4. Wlogout Power Menu
- **File**: `home/nixos/wlogout.nix` (new)
- **Purpose**: Styled logout/power menu (replaces rofi-power-menu)
- **Features**:
  - Visual icons for shutdown/reboot/logout/lock
  - CSS-styled like HyDE
  - Mouse or keyboard control

### 5. Enhanced Waybar
- **Updates to**: `home/nixos/waybar.nix`
- **New modules**:
  - Media player (shows current song, play/pause)
  - Idle inhibitor (prevent screen lock during videos)
  - Better workspace indicators
  - Backlight control display
  - Volume with scroll to adjust
- **Visual improvements**:
  - Module grouping with separators
  - Hover effects
  - Better spacing

### 6. System Utilities Package
- **File**: `modules/nixos/hyde-utils.nix` (new)
- **Packages added**:
  - `brightnessctl` - screen brightness control
  - `playerctl` - media playback control
  - `wl-color-picker` - color picker for Wayland
  - `satty` - screenshot annotation
  - `wf-recorder` - screen recording
  - `pamixer` - PulseAudio mixer
  - `pavucontrol` - GUI audio settings (enhance existing)
  - `dolphin` or `thunar` - GUI file manager
  - `fastfetch` - system info display
  - `eza` configuration - better ls
  - `bat` configuration - better cat

### 7. SwayNC Notification Center
- **File**: `home/nixos/swaync.nix` (new)
- **Replaces**: mako (basic notifications)
- **Features**:
  - Notification center panel (click to see history)
  - Do Not Disturb mode
  - Better styling and animations
  - Action buttons in notifications

### 8. Additional Sway Configuration
- **Updates to**: `home/nixos/sway.nix`
- **Adds**:
  - More workspace rules
  - Window-specific rules (floating, size, position)
  - Better keybindings for utilities
  - Scratchpad terminals
  - Smart gaps (hide when single window)

### 9. Polkit & System Integration
- **File**: `modules/nixos/system-integration.nix` (new)
- **Services**:
  - Polkit agent (for password prompts)
  - UDiskie (auto-mount USB drives)
  - Bluetooth service
  - Better XDG portal configuration

### 10. Shell Enhancements
- **Files**:
  - `home/shared/bat.nix` (update with theme)
  - `home/shared/eza.nix` (update with icons)
  - `home/shared/zsh.nix` (add more plugins)
- **What it adds**:
  - Themed bat output
  - Eza with nerd font icons
  - Better zsh completion
  - Useful aliases

## Configuration Changes Summary

### New Files to Create
```
modules/nixos/
├── sddm.nix ✓
├── hyde-utils.nix
└── system-integration.nix

home/nixos/
├── wlogout.nix
└── swaync.nix
```

### Files to Update
```
home/nixos/
├── kitty.nix (full theme integration)
├── waybar.nix (add modules, enhance styling)
└── sway.nix (more rules and keybindings)

home/shared/
├── starship.nix (enable and configure)
├── bat.nix (add theme)
└── eza.nix (add config)
```

### Packages to Add
```nix
System packages:
- brightnessctl
- playerctl
- satty
- wf-recorder
- wl-color-picker
- dolphin or thunar
- fastfetch
- polkit-gnome
- udiskie

Home packages:
- wlogout
- swaynotificationcenter
```

## What This Gives You

### Immediately After Implementation
1. **Graphical login** instead of TTY
2. **Beautiful terminal** with colors matching your theme
3. **Notification center** you can click to see history
4. **Power menu** with icons instead of text
5. **Media controls** in waybar (play/pause current song)
6. **Brightness/volume** controls visible in bar
7. **Color picker** tool (click anywhere to grab color)
8. **Screenshot annotation** (draw on screenshots before saving)
9. **File manager** GUI when you need it
10. **System info** tool (fastfetch) showing specs beautifully

### Enhanced Experience
- Everything color-coordinated through theme system
- All utilities available via keybindings
- Professional-looking desktop like HyDE
- Still minimal (not bloated like full Hydenix)

## Implementation Order

I recommend we implement in this order:

1. **Core Functionality** (Session 1)
   - System utilities package
   - Kitty terminal enhancement
   - Starship prompt
   - System integration (polkit, etc.)

2. **User Interface** (Session 2)
   - Wlogout power menu
   - SwayNC notifications
   - Enhanced waybar modules

3. **Polish** (Session 3)
   - Shell enhancements (bat, eza)
   - Additional sway rules
   - Extra utilities integration

## Theme Integration

All new components will use your existing theme system:
- Colors from `osConfig.theme.*`
- Fonts from `theme.font.*`
- Consistent look across all apps

## Testing Plan

After each component:
1. `nixos-rebuild dry-build` to check for errors
2. `nixos-rebuild switch` to apply
3. Test the feature
4. Adjust colors/settings as needed

## Questions to Consider

1. **File Manager**: Dolphin (KDE, more features) or Thunar (lighter)?
2. **Notification Position**: Keep top-right or move to top-center like some HyDE themes?
3. **Waybar Position**: Keep bottom or move to top?
4. **Power Menu**: Wlogout (graphical) or keep rofi (text-based)?

Let me know your preferences and we'll proceed!

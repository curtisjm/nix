{hostConfig, ...}: {
  imports = [
    ./terminal.nix
    ../shared/neovim.nix
    # ../shared/gastown.nix
    ../nixos/hyprland.nix
    ../nixos/kitty.nix
    ../nixos/noctalia.nix
    ../nixos/zathura.nix
    ../nixos/obsidian.nix
    ../nixos/vesktop.nix
    ../nixos/zen.nix
    ../nixos/qutebrowser.nix
    ../nixos/direnv.nix
  ];

  home.username = hostConfig.username;
  home.homeDirectory = hostConfig.homeDirectory;
  home.stateVersion = "26.05";
}

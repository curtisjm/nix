{hostConfig, ...}: {
  imports = [
    ./base.nix
    ../shared/zsh.nix
    ../shared/starship.nix
    ../shared/zoxide.nix
    ../shared/atuin.nix
    ../shared/bat.nix
    ../shared/eza.nix
    ../shared/fzf.nix
    ../shared/git.nix
    ../shared/neovim.nix
    ../shared/tmux.nix
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

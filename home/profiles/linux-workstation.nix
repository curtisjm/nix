{
  hostConfig,
  ...
}:
{
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
    ../shared/nvf
    ../shared/tmux.nix
    ../shared/opencode.nix
    ../shared/codex.nix
    ../shared/claude-code.nix
    ../nixos/hyprland.nix
    ../nixos/kitty.nix
    ../nixos/noctalia.nix
    ../nixos/zathura.nix
    ../nixos/obsidian.nix
    ../nixos/vesktop.nix
    ../nixos/qutebrowser.nix
    ../nixos/direnv.nix
  ];

  home.username = hostConfig.username;
  home.homeDirectory = hostConfig.homeDirectory;
  home.stateVersion = "25.11";
}

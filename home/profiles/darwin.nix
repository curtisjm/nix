{ hostConfig, pkgs, ... }:
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
    ../shared/ghostty.nix
    ../shared/tmux.nix
    ../shared/codex.nix
    ../shared/claude-code.nix
  ];

  home.username = hostConfig.username;
  home.homeDirectory = hostConfig.homeDirectory;
  home.stateVersion = "25.05";

  home.file = {
    ".config/yabai/yabairc".source = ../../config/yabairc;
    ".config/skhd/skhdrc".source = ../../config/skhdrc;
  };
}

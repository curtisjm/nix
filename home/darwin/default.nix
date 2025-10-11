{ pkgs, ... }:
{
    imports = [
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
    ];

    home.username = "curtis";
    home.homeDirectory = "/Users/curtis";
    home.stateVersion = "25.05";

    home.packages = [
        # pkgs.git
    ];

    home.sessionVariables = {
        # EDITOR = "nvim";
    };

    home.file = {
        ".config/yabai/yabairc".source = ../../config/yabairc;
        ".config/skhd/skhdrc".source = ../../config/skhdrc;
        ".config/nvim" = {
            source = ./nvim;
            recursive = true;
        };
    };

    programs.yazi.enable = true;

    programs.home-manager.enable = true;
}

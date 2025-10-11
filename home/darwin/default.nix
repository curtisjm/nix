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
    };

    programs.yazi.enable = true;

    programs.home-manager.enable = true;

}

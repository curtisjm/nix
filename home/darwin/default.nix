{ pkgs, ... }:
{
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

    programs.zathura.enable = true;

    programs.home-manager.enable = true;
}

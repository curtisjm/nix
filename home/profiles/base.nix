{ pkgs, ... }:
{
  home.packages = [
    pkgs.tree
  ];

  home.sessionVariables = {
  };

  home.file = {
  };

  programs.yazi.enable = true;

  programs.home-manager.enable = true;
}

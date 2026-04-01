{ pkgs, ... }:
{
  home.packages = [
    pkgs.tree
  ];

  home.sessionVariables = {
  };

  home.file = {
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
  };

  programs.home-manager.enable = true;
}

{ hostConfig, pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ../shared/ghostty.nix
    ../shared/herdr.nix
    ../nixos/direnv.nix
  ];

  home.username = hostConfig.username;
  home.homeDirectory = hostConfig.homeDirectory;
  home.stateVersion = "25.05";

  home.file = {
    ".config/skhd/skhdrc".source = ../../config/skhdrc;
  };
}

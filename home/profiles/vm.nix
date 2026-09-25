{
  hostConfig,
  ...
}:
{
  imports = [
    ./terminal.nix
    ../shared/neovim.nix
    ../nixos/i3.nix
    ../nixos/kitty.nix
    ../nixos/rofi.nix
  ];

  home.username = hostConfig.username;
  home.homeDirectory = hostConfig.homeDirectory;
  home.stateVersion = "25.11";
}

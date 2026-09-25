{ hostConfig, pkgs, ... }:
{
  imports = [
    ./terminal.nix
    ../nixos/direnv.nix
  ];

  home.username = hostConfig.username;
  home.homeDirectory = hostConfig.homeDirectory;
  home.stateVersion = hostConfig.stateVersion;
  home.packages = with pkgs; [ ripgrep fd jq btop ];

  # The desktop LazyVim module requires a separately cloned Lua configuration.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}

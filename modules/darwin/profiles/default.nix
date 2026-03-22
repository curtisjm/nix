{ inputs, ... }:
{
  imports = [
    ../base.nix
    ../system.nix
    ../packages.nix
    ../homebrew.nix
    ../fonts.nix
    ../services.nix
    ../tailscale.nix
    ../stylix.nix
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.stylix.darwinModules.stylix
  ];
}

{
  hostConfig,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../base.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.agenix.nixosModules.default
    ../theme.nix
    ../stylix.nix
    ../noctalia.nix
    ../packages.nix
    ../hyprland.nix
    ../keyd.nix
    ../fonts.nix
    ../thunar.nix
    ../regreet.nix
    ../virtualization.nix
    ../tailscale.nix
    ../../shared/emacs.nix
  ];

  custom.keyd.enable = true;

  custom.theme = {
    enable = true;
    transparency = true;
  };

  hardware.bluetooth.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs hostConfig; };
    users.${hostConfig.username} = import ../../../home/profiles/linux-workstation.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.printing.enable = true;

  users.users.${hostConfig.username}.extraGroups = lib.mkAfter [
    "libvirtd"
    "video"
  ];
}

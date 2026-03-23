{
  hostConfig,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/vm.nix
    ../../modules/nixos/sway.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  custom.theme = {
    colorScheme = "gruvbox";
    transparency = false;
  };

  users.users.${hostConfig.username}.extraGroups = lib.mkAfter [
    "video"
    "render"
  ];

  environment.systemPackages = with pkgs; [
    mesa-demos # for glxinfo debugging
  ];

  hardware.parallels.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
    ];
  };

  system.stateVersion = "25.11"; # Did you read the comment?
}

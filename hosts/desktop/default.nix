{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/workstation.nix
  ];

  custom.theme = {
    colorScheme = "rose-pine";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = false;
  hardware.graphics.enable = true;
  system.stateVersion = "25.11"; # Did you read the comment?
}

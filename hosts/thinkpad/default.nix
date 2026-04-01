{
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-13th-gen
    ../../modules/nixos/profiles/workstation.nix
    ../../modules/nixos/networking.nix
  ];

  custom.keyd.enableThinkpadMeta = true;

  custom.theme = {
    colorScheme = "rose-pine";
    transparency = lib.mkForce false;
  };

  services.tuned.enable = true;
  services.upower.enable = true;
  services.fprintd.enable = true;
  system.stateVersion = "25.11"; # Did you read the comment?
}

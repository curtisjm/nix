{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/vm.nix
    ../../modules/nixos/i3.nix # Use i3 instead of sway (X11 works better in KVM)
  ];

  environment.etc.hosts.mode = "0644";

  custom.keyd.remapSuperKey = true;

  custom.theme = {
    colorScheme = "gruvbox";
    transparency = false;
  };

  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
  services.printing.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  environment.systemPackages = with pkgs; [
    spice-vdagent
  ];

  system.stateVersion = "25.11"; # Did you read the comment?
}

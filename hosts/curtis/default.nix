{ hostConfig, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../../modules/nixos/profiles/headless-dev.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.availableKernelModules = [ "virtio_scsi" "sd_mod" ];
  services.qemuGuest.enable = true;

  # Installation contract: label the VM's ext4 root and FAT EFI partitions.
  fileSystems."/" = {
    device = "/dev/disk/by-label/curtis-root";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/CURTIS_EFI";
    fsType = "vfat";
    options = [ "umask=0077" ];
  };

  users.users.${hostConfig.username}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOKZ1VYrqOkty/ZGWIVktPKjajUZcITYmT7qYhLJSq9H 70792951+curtisjm@users.noreply.github.com"
  ];
  system.stateVersion = hostConfig.stateVersion;
}

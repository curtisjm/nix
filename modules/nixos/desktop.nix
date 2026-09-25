{ hostConfig, ... }:
{
  networking.networkmanager.enable = true;
  users.users.${hostConfig.username}.extraGroups = [ "networkmanager" ];

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  programs.firefox.enable = true;
}

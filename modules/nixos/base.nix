{
  hostConfig,
  self,
  lib,
  pkgs,
  ...
}:
let
  locale = hostConfig.locale;
in
{
  networking.hostName = hostConfig.hostname;
  networking.networkmanager.enable = true;

  time.timeZone = hostConfig.timezone;

  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  users.users.${hostConfig.username} = {
    isNormalUser = true;
    description = hostConfig.username;
    home = hostConfig.homeDirectory;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = [ ];
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [ self.overlays.default ];

  environment.systemPackages = with pkgs; [
    git
    tmux
  ];

  nix.settings.experimental-features = lib.mkDefault "nix-command flakes";
}

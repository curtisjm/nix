let
  commonConfig = {
    timezone = "America/Los_Angeles";
    locale = "en_US.UTF-8";
  };

  vmConfig = commonConfig // {
    username = "citrus";
    homeDirectory = "/home/citrus";
    hostname = "nixos";
  };

  thinkpadConfig = commonConfig // {
    username = "curtis";
    homeDirectory = "/home/curtis";
    hostname = "nixos";
    monitors = [ "eDP-1, 2880x1800@120, auto, 2" ];
    isLaptop = true;
    hasNvidia = false;
  };

  desktopConfig = commonConfig // {
    username = "curtis";
    homeDirectory = "/home/curtis";
    hostname = "nixos-desktop";
    monitors = [ ", preferred, auto, 1" ];
    isLaptop = false;
    hasNvidia = true;
  };

  mbpConfig = commonConfig // {
    username = "curtis";
    homeDirectory = "/Users/curtis";
    hostname = "mbp";
  };
in
{
  hosts = {
    parallels-vm = {
      platform = "nixos";
      path = ../hosts/parallels-vm;
      system = "aarch64-linux";
      hostConfig = vmConfig;
    };

    kvm = {
      platform = "nixos";
      path = ../hosts/kvm;
      system = "x86_64-linux";
      hostConfig = vmConfig;
    };

    desktop = {
      platform = "nixos";
      path = ../hosts/desktop;
      system = "x86_64-linux";
      hostConfig = desktopConfig;
    };

    thinkpad = {
      platform = "nixos";
      path = ../hosts/thinkpad;
      system = "x86_64-linux";
      hostConfig = thinkpadConfig;
    };

    mbp = {
      platform = "darwin";
      path = ../hosts/mbp;
      system = "aarch64-darwin";
      hostConfig = mbpConfig;
    };
  };
}

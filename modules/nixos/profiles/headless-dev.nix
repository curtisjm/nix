{ hostConfig, inputs, ... }:
{
  imports = [
    ../base.nix
    ../llm-agents.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  networking.useDHCP = true;
  networking.firewall.enable = true;
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];
  services.tailscale = {
    enable = true;
    openFirewall = true;
    extraSetFlags = [ "--shields-up=false" ];
  };

  programs.nix-ld.enable = true;
  services.fstrim.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs hostConfig; };
    users.${hostConfig.username} = import ../../../home/profiles/linux-headless.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };
}

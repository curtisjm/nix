{
  hostConfig,
  inputs,
  self,
  system,
  ...
}:
{
  users.users.${hostConfig.username} = {
    name = hostConfig.username;
    home = hostConfig.homeDirectory;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs hostConfig; };
    users.${hostConfig.username} = import ../../home/profiles/darwin.nix;
    useGlobalPkgs = true;
  };

  system = {
    primaryUser = hostConfig.username;
    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;
  };

  nixpkgs = {
    hostPlatform = system;
    config.allowUnfree = true;
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = hostConfig.username;
  };

  nix.enable = false;
  nix.settings.experimental-features = "nix-command flakes";
}

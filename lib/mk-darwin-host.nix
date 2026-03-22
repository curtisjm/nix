{
  inputs,
  self,
  nix-darwin,
}:
{
  path,
  system,
  hostConfig,
  extraModules ? [ ],
  ...
}:
nix-darwin.lib.darwinSystem {
  inherit system;
  modules = [ path ] ++ extraModules;
  specialArgs = {
    inherit
      self
      inputs
      hostConfig
      system
      ;
  };
}

{
  inputs,
  self,
  nixpkgs,
}:
{
  path,
  system,
  hostConfig,
  extraModules ? [ ],
  ...
}:
nixpkgs.lib.nixosSystem {
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

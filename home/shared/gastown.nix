{ inputs, pkgs, ... }:
let
  system = pkgs.stdenv.hostPlatform.system;
  gt = inputs.gastown.packages.${system}.gt.overrideAttrs (old: {
    goModules = old.goModules.overrideAttrs (_: {
      outputHash = "sha256-mJzpsl4XnIm3ZSg7fFn0MOdQQW1bdOkAJ+TikiLMXJM=";
    });
  });
in
{
  home.packages = [
    gt
    pkgs.dolt
    pkgs.sqlite
  ];
}

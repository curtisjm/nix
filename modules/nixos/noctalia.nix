{ pkgs, inputs, ... }:
let
  noctalia-shell = import ../../lib/noctalia-shell-package.nix { inherit inputs pkgs; };
in
{
  # install package
  environment.systemPackages = [
    noctalia-shell
  ];
}

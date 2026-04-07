# Temporary: pin claude-code to 2.1.92 from a newer nixpkgs commit.
# Remove this overlay once nixos-unstable includes claude-code >= 2.1.92.
final: prev:
let
  nixpkgs-claude = import (prev.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "20e346320f6e089ab8621328d0399579d1dd3bff";
    hash = "sha256-QrdX3s22Q78IBL2pzGhQFMjkHgJd/doDrrI+vYLqNOA=";
  }) {
    inherit (prev) system;
    config.allowUnfree = true;
  };
in
{
  claude-code = nixpkgs-claude.claude-code;
}

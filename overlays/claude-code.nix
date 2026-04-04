# Temporary: pin claude-code to 2.1.91 from a newer nixpkgs commit.
# Remove this overlay once nixos-unstable includes claude-code >= 2.1.89.
final: prev:
let
  nixpkgs-claude = import (prev.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "5c226f3790a3";
    hash = "sha256-7PGZa8uixUmZi1Fmeb2EzLNl8VfVpIhEn0baAyz4Pb0=";
  }) {
    inherit (prev) system;
    config.allowUnfree = true;
  };
in
{
  claude-code = nixpkgs-claude.claude-code;
}

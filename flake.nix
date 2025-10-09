{
    description = "Citrus MBP nix-darwin system flake";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        nix-darwin.url = "github:nix-darwin/nix-darwin/master";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

        nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    };

    outputs =
        inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
        {
            darwinConfigurations."mbp" = nix-darwin.lib.darwinSystem {
                modules = [
                    ./darwin/system.nix
                    ./darwin/packages.nix
                    ./darwin/homebrew.nix
                    ./darwin/fonts.nix

                    {
                        system.primaryUser = "curtis";
                        nixpkgs.config.allowUnfree = true;
                        nix.settings.experimental-features = "nix-command flakes";
                        system.configurationRevision = self.rev or self.dirtyRev or null;
                        system.stateVersion = 6;
                        nixpkgs.hostPlatform = "aarch64-darwin";
                    }

                    nix-homebrew.darwinModules.nix-homebrew
                    {
                        nix-homebrew = {
                            enable = true;
                            enableRosetta = true;
                            user = "curtis";

                            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                            # mutableTaps = false;
                        };
                    }

                ];
            };
        };
}

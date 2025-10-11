{ self, inputs, pkgs, ...}:
{
    imports = [
        ../../modules/darwin/system.nix
        ../../modules/darwin/packages.nix
        ../../modules/darwin/homebrew.nix
        ../../modules/darwin/fonts.nix
        inputs.home-manager.darwinModules.home-manager
        inputs.nix-homebrew.darwinModules.nix-homebrew
    ];

   home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = {
            curtis = import ../../home/darwin;
        };
    };

    system = {
        primaryUser = "curtis";
        configurationRevision = self.rev or self.dirtyRev or null;
        stateVersion = 6;
    };

    nixpkgs = {
        hostPlatform = "aarch64-darwin";
        config.allowUnfree = true;
    };

    nix-homebrew = {
        enable = true;
        enableRosetta = true;
        user = "curtis";

        # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
        # mutableTaps = false;
    };

    services.yabai = {
        enable = true;
        package = pkgs.yabai;
        enableScriptingAddition = true;
    };

    services.skhd = {
        enable = true;
        package = pkgs.skhd;
    };

    nix.settings.experimental-features = "nix-command flakes";
}

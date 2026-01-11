{
    description = "Configuration for NixOS and MacOS";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        nix-homebrew.url = "github:zhaofengli/nix-homebrew";
        hyprland.url = "github:hyprwm/Hyprland";
        nix-darwin = {
            url = "github:nix-darwin/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };
        stylix = {
            url = "github:nix-community/stylix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{self, nixpkgs, nix-darwin, nix-homebrew, home-manager, hyprland, hyprland-plugins, stylix}:
        {
            nixosConfigurations = {
                vm = nixpkgs.lib.nixosSystem {
                    system = "aarch64-linux";
                    modules = [ ./hosts/vm ];
                    specialArgs = { inherit self inputs; };
                };
                desktop = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [ ./hosts/desktop ];
                    specialArgs = { inherit self inputs; };
                };
                laptop = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [ ./hosts/laptop ];
                    specialArgs = { inherit self inputs; };
                };
            };

            darwinConfigurations = {
                mbp = nix-darwin.lib.darwinSystem {
                    system = "aarch64-darwin";
                    modules = [ ./hosts/mbp ];
                    specialArgs = { inherit self inputs; };
                };
            };
        };
}

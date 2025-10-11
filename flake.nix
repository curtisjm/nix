{
    description = "Configuration for NixOS and MacOS";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        nix-darwin.url = "github:nix-darwin/nix-darwin/master";
        nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
        nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    };

    outputs = inputs@{self, nixpkgs, nix-darwin, nix-homebrew, home-manager}:
        {
            nixosConfigurations = {
                vm = nixpkgs.lib.nixosSystem {
                    system = "aarch64-linux";
                    modules = [ ./hosts/vm ];
                };
                desktop = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [ ./hosts/desktop ];
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

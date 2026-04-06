{
  description = "Configuration for NixOS and MacOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    superpowers = {
      url = "github:obra/superpowers";
      flake = false;
    };
    openai-skills = {
      url = "github:openai/skills";
      flake = false;
    };
    gastown.url = "github:gastownhall/gastown";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      home-manager,
      hyprland,
      hyprland-plugins,
      stylix,
      nixos-hardware,
      noctalia,
      zen-browser,
      nvf,
      agenix,
      superpowers,
      openai-skills,
      gastown,
    }:
    let
      lib = nixpkgs.lib;
      hostInventory = import ./lib/hosts.nix;
      mkNixosHost = import ./lib/mk-nixos-host.nix {
        inherit inputs self nixpkgs;
      };
      mkDarwinHost = import ./lib/mk-darwin-host.nix {
        inherit inputs self nix-darwin;
      };
      activeNixosHosts = lib.filterAttrs (_: metadata: metadata.platform == "nixos") hostInventory.hosts;
      activeDarwinHosts = lib.filterAttrs (
        _: metadata: metadata.platform == "darwin"
      ) hostInventory.hosts;
    in
    {
      overlays = import ./overlays;

      nixosConfigurations = lib.mapAttrs (_: metadata: mkNixosHost metadata) activeNixosHosts;

      darwinConfigurations = lib.mapAttrs (_: metadata: mkDarwinHost metadata) activeDarwinHosts;
    };
}

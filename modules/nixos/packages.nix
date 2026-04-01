{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  categories = {
    cli = with pkgs; [
      ripgrep
      fd
      bat
      tldr
      btop
      yt-dlp
      openssl
      fastfetch
      keyd
    ];

    dev = with pkgs; [
      go
      python3
      ruff
      pyright
      nil
      cargo
      rustc
      rust-analyzer
      cmake
      gcc
      nodejs
      code-cursor-fhs
    ];

    containers = with pkgs; [
      docker
      docker-compose
      colima
    ];

    browsers = with pkgs; [
      google-chrome
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    communicationPlatforms = with pkgs; [
      zoom-us
      slack
      telegram-desktop
    ];

    desktopUtilities = with pkgs; [
      proton-vpn
      darktable
      texliveFull
    ];
  };
in
{
  options.custom.packageCategories = lib.mkOption {
    type = with lib.types; listOf (enum (builtins.attrNames categories));
    default = [ ];
    description = "Optional package categories to add to environment.systemPackages.";
    example = [
      "cli"
      "dev"
      "browsers"
    ];
  };

  config.environment.systemPackages = lib.unique (
    lib.concatLists (map (category: categories.${category}) config.custom.packageCategories)
  );
}

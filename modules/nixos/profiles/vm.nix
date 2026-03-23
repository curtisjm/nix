{
  hostConfig,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../base.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    ../theme.nix
    ../stylix.nix
    ../packages.nix
    ../security-packages.nix
    ../keyd.nix
    ../fonts.nix
    ../thunar.nix
  ];

  custom.keyd.enable = true;
  custom.theme.enable = true;

  custom.packageCategories = lib.mkDefault [
    "cli"
    "dev"
    "containers"
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs hostConfig; };
    users.${hostConfig.username} = import ../../../home/profiles/vm.nix;
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];
}
